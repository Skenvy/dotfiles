# GPG
> [!NOTE]
> These tips _originally_ started in [this gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0#gpg).
>
> The gist originally dealt with ssh only, so for gpg, there's less to say.
---
These tips are focussed _mostly_ on WSL and Windows _**side-by-side**_. Because that's _my_ home development environment. They started as notes for me to remember the unique flavour of managing multiple ssh keys for multiple GitHub account, and using these keys on both Windows and WSL.

This should be a minimal way to set up gpg for use on Mac, Windows, and WSL.

GPG, GNU's [OpenPGP](https://www.openpgp.org/), uses `~/.gnupg` (or `%APPDATA%/gnupg` on windows) as the default home directory which contains a `gpg.conf` and `common.conf` for user config plus any other files in `~/.gnupg/*` | `%APPDATA%/gnupg` for an internal store. Other config files include the `gpg-agent.conf` and the `dirmngr.conf`.

See the docs on:
* [GitHub: Managing commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification)
* [gnupg downloads](https://www.gnupg.org/download/) (the "Simple installer for the current GnuPG" is easiest for Windows)
* [Configuration files](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html)
* [Option Summary](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html)
* [bfrg/gpg-guide](https://github.com/bfrg/gpg-guide)

## First time setup: symlinks and checkins?
### Symlink setup (or why we _don't_ symlink for gpg)
WSL doesn't currently have anything that matches `/etc/skel/.gnupg/*`, so for WSL's perpective, we'd need to make these files ourselves if we care to. However, Windows installations of GPG use `~/AppData/Roaming/gnupg/*`. We could theoretically support a "single point of config" by symlinking our Windows `~/AppData/Roaming/gnupg/*` to WSL `~/.gnupg/*`, and this would be the simplest way to have both be aware of the same keys. However, the versions of gpg that can be installed on windows, in Ubuntu, and come pre-included in "git bash" all appear to have slight variations in their version and internal key-store. On top of this, the version of gpg that comes with "git bash" uses the Windows home folder's `~/.gnupg` the same as in WSL / Mac, which would clash with any attempt to symlink WSL's `~/.gnupg` and Windows `~/AppData/Roaming/gnupg/*` to Windows `~/.gnupg`. For example my current installation of git-bash includes a gpg version old enough that it does not work with the `keyboxd` setting, which is now the _default_ setting in the versions of gpg that are already installed in WSL, Mac's latest brew, _and_ the latest Windows build.

So, for gpg, we specifically don't bother trying to set up elaborate symlinking.
> [!IMPORTANT]
> For consistency, we should use `~/.gnupg` for Ubuntu / Mac's config, and also check in the config from `~/AppData/Roaming/gnupg` for Windows, and recommend avoiding using the gpg that comes installed with git-bash.
### Why aren't any of the `*.conf`'s checked in here?
You might look at this folder and reasonably wonder why none of the config files are checked in, when that's the whole point of a dotfiles repo!

All the other configs checked in in other parts of this are all "extensible" either via sourcing or some variation of including other config. Such sourcing / indirect inclusion of other config files is not supported in gpg, but it remains one of several tools significant enough to setting up a new environment, that it was worth documenting here with this README.
The first time you run gpg it may or may not create any of the config files and populate them with some options. Most notably `use-keyboxd` is a default option that will frequently appear in `common.conf` these days.

> [!TIP]
> We shouldn't really _need_ to centrally manage our gpg configuration, and for the most part it should be fine to simply mention config settings required for any potential use case if they are ever strictly required to fix something, but other than that, we shouldn't have any need to add them in here.
> _If_ at some point you want to add gpg config files here in the `home` branch expecting this to be used in the style of "`$HOME` is a repo", then to enable a downstream repo submoduling this in the "`$HOME` is another repo" pattern, you will need to either: replace the `rehome` alias with one that sets `CLOBBER_CHECKEDIN_ROOT` to `WARN`; or add the submoduling repo's gpg config in a differently named file and add an alias to replace the `gpg` command with one that provides to it multiple instances of `--options`.

But other than if you choose to clone this repo and use it in that way, we will plan to mostly use the default config.
## Creating a new key
