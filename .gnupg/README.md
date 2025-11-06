# GPG
> [!NOTE]
> These tips _originally_ started in [this gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0#gpg).
>
> They originally expected a trade-off of not checking in your `~/.gnupg/*`. Now they support it!
---
> [!TIP]
> These tips are focussed _mostly_ on WSL and Windows _**side-by-side**_. Because that's _my_ home development environment. They started as notes for me to remember the unique flavour of managing multiple ssh keys for multiple GitHub account, and using these keys on both Windows and WSL.
>
> This should be a minimal way to set up gpg for use on Mac, Windows, and WSL.
---
> [!IMPORTANT]
> [GPG](https://www.gnupg.org/), GNU's [OpenPGP](https://www.openpgp.org/), uses `~/.gnupg` (or `%APPDATA%/gnupg` on windows (where `%APPDATA%` ~= `~/AppData/Roaming`)) as the default home directory, which contains a `gpg.conf` and `common.conf` for user config, plus additional config files such as `gpg-agent.conf` and `dirmngr.conf`. Besides these, other files in the GPG home directory include the internal store e.g. keyrings.

See the docs on:
* [GitHub: Managing commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification)
* [GitHub: Telling Git about your signing key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
* [GnuPG Org: gnupg downloads](https://www.gnupg.org/download/)
* [GnuPG Org: Configuration files](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html)
* [GnuPG Org: Option Summary](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html)
* [Sonatype: GPG](https://central.sonatype.org/publish/requirements/gpg/) (includes steps on "expired keys")
* [Example: bfrg/gpg-guide](https://github.com/bfrg/gpg-guide)

## First time setup
> [!CAUTION]
> This section is only relevant if you are setting up your dotfiles repo to check-in your `~/.gnupg/*.conf`.
> Or to read about GitHub's vigilant mode.
> If you are not, then the rest of this guide is still situationally useful, but this section will be irrelevant.
### Dotfiles
To check-in our user config for GPG, `~/.gnupg/*.conf`, without being able to make use of our [dotfile inclusion methodology](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#include) _because GPG does not have any sort of inclusion mechanism_, yet still adhere to both patterns that we support (where this repo is either `$HOME` itself or a submodule that we symlink into `$HOME` with clobber protection), we must use the [`CLOBBER_CHECKEDIN_ROOT_IGNORELIST` option](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#dotfiles-submodule-symlinks) in our [submodule support script](./bin/dotfiles-submodule-symlinks) (see the example  [base dotfiles-submodule-symlinks-hook](https://github.com/Skenvy/dotfiles/blob/base/.include/dotfiles-submodule-symlinks-hook.sh) where you would need to list any gpg config files you would add to a repository that would submodule this one).

The first time you run gpg it may or may not create any of the config files and populate them with some options. Most notably `use-keyboxd` is a default option that will frequently appear in `common.conf` these days.

### Vigilant mode
> [!IMPORTANT]
> Don't let someone else impersonate you!
> See GitHub's [Enabling "vigilant mode"](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits#enabling-vigilant-mode) docs.

Anyone can `git commit` with settings that will label their commits with your identity and `git push` them to any repository, which will show up as if _you_ authored the commit! Setting up gpg is not just to provide a method of guaranteeing authorship from the perspective solely of a repository maintainer / organisation, but also of guaranteeing that only commits you sign are demonstrably authored by you. Setting "vigilant mode" in GitHub will still allow non-signed commits claiming to be authored by you to be pushed, but they will display a status next to them that clearly marks them as "unverified" commits.

### Symlink setup

<details>

<summary>... or why we DON'T symlink for gpg.</summary>

WSL doesn't currently have anything that matches `/etc/skel/.gnupg/*`, so for WSL's perpective, we'd need to make these files ourselves if we care to. However, Windows installations of GPG use `~/AppData/Roaming/gnupg/*`. We could theoretically support a "single point of config" by symlinking our Windows `~/AppData/Roaming/gnupg/*` to WSL `~/.gnupg/*`, and this would be the simplest way to have both be aware of the same keys. However, the versions of gpg that can be installed on windows, in Ubuntu, and come pre-included in "git bash" all appear to have slight variations in their version and internal key-store. On top of this, the version of gpg that comes with "git bash" uses the Windows home folder's `~/.gnupg` the same as in WSL / Mac, which would clash with any attempt to symlink WSL's `~/.gnupg` and Windows `~/AppData/Roaming/gnupg/*` to Windows `~/.gnupg`. For example my current installation of git-bash includes a gpg version old enough that it does not work with the `keyboxd` setting, which is now the _default_ setting in the versions of gpg that are already installed in WSL, Mac's latest brew, _and_ the latest Windows build.

</details>

## Install
Install with the following, and use these commands to diagnose where you've installed to!

We'll need to know the path that gpg was installed to later when setting the git config's `gpg.program`. These list the commands to use to ensure you're using the right path.
1. Apt pkg gnupg for WSL ([`apt show gnupg` | `sudo apt install gnupg`](https://packages.ubuntu.com/search?keywords=gnupg))
    * get the path with `which -a gpg` (and `type gpg`)
1. Brew GPG for Mac ([`brew install gnupg`](https://formulae.brew.sh/formula/gnupg) | [`brew install pinentry-mac`](https://formulae.brew.sh/formula/pinentry-mac))
    * get the path with `which -a gpg` (and `type gpg`)
1. For Windows, the "Simple installer for the current GnuPG" on the [gnupg downloads](https://www.gnupg.org/download/) page is the easiest option.
    * get the path with `where gpg` (cmd) or `(Get-Command gpg).source` (pwsh)

> [!WARNING]
> For Windows users, the included pin-entry program may not function properly if it is installed without specifically installing it as an admin. So make sure you install it as admin to ensure the pin-entry program works!
>
> If you install the "Simple installer ..." as an admin, it should by default end up in `C:\Program Files (x86)\GnuPG\bin\gpg.exe`. If you install it without elevating to admin it will install to your user specific `AppData/Local` folder.
>
> If you have an install in your `AppData/Local` and you're experiencing issues with pin-entry, delete that install, clear the path entries for it, and reinstall as admin.
>
> Regardless of install location, `gpg --version` on Windows will tell you your `HOME` is in your `AppData/Roaming`. This is expected.

> [!CAUTION]
> For Windows users we specifically recommend _against_ using the version of gpg packaged with `git bash`, that would have been installed by [git for windows](https://git-scm.com/install/windows), as it can be significantly older than the current version on the [gnupg downloads](https://www.gnupg.org/download/) page, and it uses a different internal format to store keys. It will be the default gpg used by git inside of the `git bash` program, but will be difficult to use _outside_ of `git bash`.
>
> ONLY use "git bash" if you are planning on only ever using "git bash", it is very inconsistent with all the other options. If you're following this setup on Windows, use `cmd` or `powershell` to do these steps on the recommended "Simple installer ..." version.

## Listing keys and configuring git
> [!IMPORTANT]
> If this is your first time, remember to come back to this section _after_ creating your key below.
### Listing keys
`gpg --list-keys` will show you a list of known keys. To see all _secret_ keys (with the key ID in the `pub`/`sec`)
```bash
gpg --list-secret-keys --keyid-format=long
# Will print each secret key with a line like ~ i.e.
# sec   <Algo>/<16-char-key-ID> ~ e.g.
# sec   rsa3072/1234567890ABCDEF
gpg --armor --export 1234567890ABCDEF
# Prints the GPG public key, in ASCII armor format
```
### Configuring GitHub
If you're adding this key to GitHub, paste your pretty printed public key from the above's `--armour --export` into this [new gpg key form](https://github.com/settings/gpg/new).
### Configuring git
From the `sec` line in the example, for the key we want to use, we take the 16 character key ID and...
```bash
git config --global user.signingkey 1234567890ABCDEF
# If you don't set commit.gpgsign true, then you'll
# need to manually sign commits with the -S option
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global --unset gpg.format # default openpgp
# If you `which gpg` / `where gpg` and get a path you can enter then ~
git config --global gpg.program "<the path you got from which|where gpg>"
```
For _**examples**_ of the `gpg.program` option across different OS, see the [pre includes README](../.include/.pre/README.md). If you aren't following along setting up your dotfiles as this repository suggests, the examples of `gpg.program` should go in your default `~/.gitconfig`.
### Diagnose your git config
> [!TIP]
> If you're struggling to diagnose where a setting is getting applied or misapplied, you can use
> ```bash
> git config --list --show-origin --show-scope
> # Or...
> git config --list --show-origin --show-scope | grep gpg
> ```
> This will show you all your options and which files are setting them in what order.
## Creating a new key
Creating a new key is "simple". All we need is;
```bash
gpg --full-generate-key
# Please select what kind of key you want:
# ~ Various parameter selection questions depending on algorithm ~
# Please specify how long the key should be valid.
# Real name:
# Email address:
# Comment:
# Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?
```
The main thing we need to consider though, is, depending on what service we want to use the new key with, that some services will have particular requirements for how keys are created, e.g. algorithm strength, _supported_ algorithms, and key-size. So if you are creating a key specifically for use with a given service, that service will likely have a page documenting how they would expect you to create a key, which might be generic steps, or specific choices in the above selections.

Here are some pages for services that provide key pair generation docs.
* [GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
* [Maven](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair)

### Passphrase
> [!NOTE]
> You can-be / will-be asked for a "passphrase" during key creation. This is essentially a password on the key itself, that you'll need to type every-time / most-times you want to use your key to sign anything. Gpg will tell you it's less secure to leave your passphrase blank, but it's up to you. Leaving it blank will mean you won't be prompted for it semi-regularly.

### E-mail
> [!NOTE]
> Ideally you'll use the same email for your key as you have set in your git config for your user email, but this is not a requirement for GitHub.

## Export/Import a key
A public and or private key can be exported with `--export` + `--armour`|`--armour` to make it base64 readable rather than the otherwise default binary output. Both the default binary stream and the `--armour`'d base64 output can be imported with `--import`. If you are exporting and importing the private key, it includes the public key, so there is no need to do both.
### Export a public key for GitHub
> [!TIP]
> Refer to the above section on [listing keys and configuring git](../.gnupg/README.md#listing-keys-and-configuring-git). Use the example `gpg --armor --export 1234567890ABCDEF` with whatever your key's ID is. You should get a pretty printed public key block. Upload this entire output to your [GitHub account settings "SSH and GPG keys"](https://github.com/settings/keys) ([new gpg key entry form](https://github.com/settings/gpg/new)).
### Exporting and Importing between Windows and WSL
As far as we are concerned here with using GPG and the same keys across both WSL and Windows, we can create the keys in one, and export them then import them in the other, and then securely delete the exported private keys.
```bash
# Export the public and private keys in binary
gpg --export $ID > public.key
gpg --export-secret-key $ID > private.key
# Import the public and private keys in binary
gpg --import public.key
gpg --import private.key

# Finally, if this is _your_ ultimate key...
gpg --edit-key $ID trust quit
# enter 5 <RETURN> (I trust ultimately)
# enter y <RETURN> (Really set this key to ultimate trust - Yes)
```
## Expired keys
These very useful sonatype docs will show you about [dealing with expired keys](https://central.sonatype.org/publish/requirements/gpg/#dealing-with-expired-keys).
## Keyservers
> [!TIP]
> The key ID you get from listing keys with the option `--keyid-format=long` is the last 16 characters of the full 40 character ID.
> ```bash
> # Note the FULL 40 character key ID will appear underneath the sec line, like;
> # sec   <Algo>/<16-char-short-key-ID> <date-created> [SC] [expires: <expiry>]
> #       <24-leading-char-key-ID><16-char-short-key-ID>
> # e.g. my public key on several keyservers
> # sec   rsa3072/C203EA8449D06C1B 2022-05-26 [SC] [expires: 2030-06-11]
> #       F398EA6448A7708EAABBB0DEC203EA8449D06C1B
> ```
> You can upload your public key to a keyserver if necessary, using, per this example
> ```bash
> # gpg --keyserver <keyserver-host> --send-keys <40-char-key-ID>
> gpg --keyserver keyserver.ubuntu.com --send-keys F398EA6448A7708EAABBB0DEC203EA8449D06C1B
> ```
> This example shows _my_ key uploaded to the ubuntu keyserver [F398EA6448A7708EAABBB0DEC203EA8449D06C1B](https://keyserver.ubuntu.com/pks/lookup?search=F398EA6448A7708EAABBB0DEC203EA8449D06C1B&fingerprint=on&op=index), your key ID will obviously be different.
## Pin-entry
### Mac
For GPG on Mac you will need both the [GPG](https://formulae.brew.sh/formula/gnupg) brew and the [pinentry-mac](https://formulae.brew.sh/formula/pinentry-mac) brew.

You'll also need to set `~/.gnupg/gpg-agent.conf` to:
```txt
pinentry-program /opt/homebrew/bin/pinentry-mac
```
