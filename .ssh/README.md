# SSH
> [!NOTE]
> These tips _originally_ started in [this gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0#ssh).
>
> They originally expected a trade-off of not checking in your `~/.ssh/config`. Now they support it!
---
These tips are focussed _mostly_ on WSL and Windows _**side-by-side**_. Because that's _my_ home development environment. They started as notes for me to remember the unique flavour of managing multiple ssh keys for multiple GitHub account, and using these keys on both Windows and WSL.

This should be a minimal way to set up new keys for using multiple accounts on Mac, Windows, and WSL, and covers some of the traps in simultaneous use of **Windows _AND_ WSL**.

See the docs on:
* [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
* [All SSH manuals](https://www.openssh.com/manual.html)
* [SSH client conf](https://man.openbsd.org/ssh_config)
* [SSH's "include" directive](https://man.openbsd.org/ssh_config#Include)
* [Using ssh with vs code devcontainers](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)
## First time setup: Linking config from Windows in to WSL
This guide favours having the config for SSH checked-in, but for the keys, and other temporary / non-checked-in files, they will be **stored in Windows** and _symlinked in to WSL_.
### Symlink the _whole_ directory (easier, not checked-in config)
The easiest option as a set and forget, if you want minimal management (which DOESN'T easily support checked-in config), is, from within WSL;
```bash
# Set YOUR_WINDOWS_USERNAME to whatever it is.
YOUR_WINDOWS_USERNAME=example
mkdir -p /mnt/c/Users/$YOUR_WINDOWS_USERNAME/.ssh
ln -s /mnt/c/Users/$YOUR_WINDOWS_USERNAME/.ssh ~/.ssh
```
### Symlink each file/folder in the ssh folder (less easy, allows checked-in config)
To support checking in an ssh config but making it easier to keep the rest of the contents symlinked, I personally set a `LOCAL_WINDOWS_USERNAME` in my `~/.include/.pre/.bashrc`. Then, I can use this with these two aliases to rerun `wsl_resym_ssh` whenever I need to make sure my Windows `~/.ssh` is symlinked into my WSL `~/.ssh`. Note that the alias only works as expected while we only track files directly in the `.ssh` folder, and would break if we checked-in anything nested in a folder. This works here because all I have accounted for checking in is my `~/.ssh/config` and this `~/.ssh/README.md`. The aliases used for this are then;
```bash
# LOCAL_WINDOWS_USERNAME set in some bashrc before these aliases
alias tracking="git ls-tree --full-tree --name-only -r HEAD"
alias wsl_resym_ssh="( shopt -s dotglob; WINDOWS_PATH=\"/mnt/c/Users/\$LOCAL_WINDOWS_USERNAME/\"; for f in \$WINDOWS_PATH.ssh/*; do  grep -qx \"\$(tracking)\" <<< \"\${f/\$WINDOWS_PATH/}\" && echo \"TRACKED FILE NOT SYM'd \$f\" || (echo \"UNTRACKED WILL BE LINKED \$f\" && ln -sf \"\$f\" ~/\${f/\$WINDOWS_PATH/}); done )"
```
## Creating a new key
To connect from "this machine" to a new GH account. While `~` will be different from your Windows and WSL's perspective, WSL's `~/.ssh` _should_ be a **soft link** to your window's `~/.ssh`, so it's ok to use either.
```bash
# Make the key
EMAIL=your_email@example.com
KEYNAME=GH_Username
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/$KEYNAME
```
## Upload the public key
Upload the public key `cat ~/.ssh/$KEYNAME.pub` to https://github.com/settings/ssh/new as an "Authentication Key" with some name.
## Add the new key to the ssh-agent
### Enable `chmod`'ing' the keys stored in Windows filesystem from WSL
If you're going to `chmod` you might need to add the following to `sudo vi /etc/wsl.conf` from WSL
```ini
[automount]
options = "metadata"
```
and then close all sessions and `wsl --shutdown` from cmd/pwsh, and apply the user read only permissions to the key, which is required by \*nix's openssh but appears to have no affect on windows' ssh-agent.
```bash
chmod 400 ~/.ssh/$KEYNAME # Variable name is example only, and won't always work here, favour not using variable.
```
### Now you can start the ssh-agent
#### On Windows
```pwsh
Get-Service -Name ssh-agent | Start-Service
# Or to make it automatic, from an admin pwsh
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
```
#### On WSL
Add the following to `~/.bashrc` to allow ssh-agent to start automatically.
```bash
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s` > /dev/null
    # ssh-add
fi
```
Without this, it can be started manually each time with `eval "$(ssh-agent -s)"`
### And add the key to the agent
```bash
ssh-add ~/.ssh/$KEYNAME
```
### but you need to do this for BOTH windows _AND_ wsl, they use distinct agents.
## Testing ssh / ssh-agent
This should show you which keys the agent is aware of, and which one is being used by `ssh`. You should treat the agent as ephemeral. It's best to only have whatever key you need to use loaded one at a time. You can run `ssh-add -D` to remove all currently added keys if necessary, then manually add back `ssh-add path/to/file`. That's best to do, but if you need to test what it's doing, here's how.
```bash
ssh-add -l
ssh -vT git@github.com
```
### But then things get dicey...
By using the `ssh -v` setting in the environment variable `GIT_SSH_COMMAND` (which supersedes `GIT_SSH`), and trying to git pull / clone for an account that has its key in the agent, we can see an issue. It appears git uses the ssh-agent on \*nix by default but not on windows? To add ssh-agent to the keys tried by git on windows, open powershell and;
```pwsh
[Environment]::SetEnvironmentVariable("GIT_SSH", "$((Get-Command ssh).Source)", [System.EnvironmentVariableTarget]::User)
```
Which should be a persistent fix!
### Set the GIT_SSH_COMMAND to verbose
| Shell | Command                           |
| ---   | ---                               |
| sh    | `export GIT_SSH_COMMAND="ssh -v"` |
| cmd   | `set GIT_SSH_COMMAND=ssh -v`      |
| pwsh  | `$env:GIT_SSH_COMMAND='ssh -v'`   |

However, the `ssh` reference in pwsh is slightly more cumbersome. For some reason, although backslashes cause no issue in `GIT_SSH`, as set by the above, `Write-Host $env:GIT_SSH_COMMAND` yielding the same output as `Write-Host $env:GIT_SSH` results in git trying to use the path for `Get-Command ssh` without backslashes. So to add verbose temporarily to `GIT_SSH_COMMAND` in pwsh, we need the following.
```pwsh
[Environment]::SetEnvironmentVariable("GIT_SSH_COMMAND", "$(((Get-Command ssh).Source).replace('\','/')) -v", [System.EnvironmentVariableTarget]::Process)
```
### Then things get even more dicey (if you have more than one key regiested).
Git's SSH doesn't retry when a key is _accepted_ but **not valid**. That is to say, when multiple keys are added to the agent, it appears the first key that could be accepted by the site, will be. In other words, if multiple keys will be accepted by a server, because they are all _valid_ for **something**, the first key to be accepted, might not be valid for the account you're trying to access!! For example, `ssh-add A` followed by `ssh-add B` will make git attempt to use key `B` first. If the account for the repo you're working with has key `A` attached to it, and `B` is attached to _some other account_, then key `B` will be "accepted", and then subsequently denied as not being for that account.
### The ssh-agent is ephemeral!
The agent, besides however it interacts with keychain on mac, is totally ephemeral on wsl. So it would not be unreasonable to assume if you want to work with the ssh-agent to handle keys, that you'd be familiar with `ssh-add -l` to list the keys in the agent, and `ssh-add -D` to remove all active one. While The agent is ephemeral on WSL, and will need specific keys added on each start up, without a default one being loaded in an `rc`, Windows appears to store the keys in the agent permanently, so would need to have the previous entry deleted before adding another (it will use whatever the most recent unique addition was that was not already present).
## Set your remote URL from HTTPS to SSH
If you've been using some https method, you'll need to update, or add a remote that uses ssh instead.
```bash
# HTTPS format is https://github.com/USERNAME/REPOSITORY.git
git remote get-url --all origin
git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
```
