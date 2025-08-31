# GPG
> [!NOTE]
> These tips _originally_ started in [this gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0#gpg).
>
> The gist originally dealt with ssh only, so for gpg, there's less to say. Because I use this repo in _both_ the patterns it supports, I avoid checking in my config. This is instead just snippets of things to do.
---
These tips are focussed _mostly_ on WSL and Windows _**side-by-side**_. Because that's _my_ home development environment. They started as notes for me to remember the unique flavour of managing multiple ssh keys for multiple GitHub account, and using these keys on both Windows and WSL.

This should be a minimal way to set up gpg for use on Mac, Windows, and WSL.

GPG, GNU's [OpenPGP](https://www.openpgp.org/), uses `~/.gnupg` (or `%APPDATA%/gnupg` on windows) as the default home directory which contains a `gpg.conf` and `common.conf` for user config plus any other files in `~/.gnupg/*` | `%APPDATA%/gnupg` for an internal store. Other config files include the `gpg-agent.conf` and the `dirmngr.conf`.

See the docs on:
* [GitHub: Managing commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification)
* [GitHub: Telling Git about your signing key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
* [GnuPG Org: gnupg downloads](https://www.gnupg.org/download/) (the "Simple installer for the current GnuPG" is easiest for Windows)
* [GnuPG Org: Configuration files](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html)
* [GnuPG Org: Option Summary](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html)
* [Sonatype: GPG](https://central.sonatype.org/publish/requirements/gpg/) (includes steps on "expired keys")
* [Example: bfrg/gpg-guide](https://github.com/bfrg/gpg-guide)

## First time setup: symlinks and checkins?
### TL:DR
The TLDR here is that we do _not_ check in any of the gpg `*.conf` files, and why if we chose to, we would not want to symlink them.
We also recommend the default package manager's gpg for WSL, the brew GPG for Mac, and the "Simple installer for the current GnuPG" version for Windows.
We specifically recommend against using the version of gpg packaged with "git bash" as it can be significantly older than the current version, and it uses a different internal format to store keys than the one we can download from [gnupg downloads](https://www.gnupg.org/download/). For more explanation open either of these two sections;

<details>
<summary>Symlink setup (or why we don't symlink for gpg)</summary>

### Symlink setup (or why we _don't_ symlink for gpg)
WSL doesn't currently have anything that matches `/etc/skel/.gnupg/*`, so for WSL's perpective, we'd need to make these files ourselves if we care to. However, Windows installations of GPG use `~/AppData/Roaming/gnupg/*`. We could theoretically support a "single point of config" by symlinking our Windows `~/AppData/Roaming/gnupg/*` to WSL `~/.gnupg/*`, and this would be the simplest way to have both be aware of the same keys. However, the versions of gpg that can be installed on windows, in Ubuntu, and come pre-included in "git bash" all appear to have slight variations in their version and internal key-store. On top of this, the version of gpg that comes with "git bash" uses the Windows home folder's `~/.gnupg` the same as in WSL / Mac, which would clash with any attempt to symlink WSL's `~/.gnupg` and Windows `~/AppData/Roaming/gnupg/*` to Windows `~/.gnupg`. For example my current installation of git-bash includes a gpg version old enough that it does not work with the `keyboxd` setting, which is now the _default_ setting in the versions of gpg that are already installed in WSL, Mac's latest brew, _and_ the latest Windows build.

So, for gpg, we specifically don't bother trying to set up elaborate symlinking.
> [!IMPORTANT]
> For consistency, we should use `~/.gnupg` for Ubuntu / Mac's config, and also check in the config from `~/AppData/Roaming/gnupg` for Windows, and recommend avoiding using the gpg that comes installed with git-bash.

</details>

<details>
<summary>Why aren't any of the `*.conf`'s checked in here?</summary>

### Why aren't any of the `*.conf`'s checked in here?
You might look at this folder and reasonably wonder why none of the config files are checked in, when that's the whole point of a dotfiles repo!

All the other configs checked in in other parts of this are all "extensible" either via sourcing or some variation of including other config. Such sourcing / indirect inclusion of other config files is not supported in gpg, but it remains one of several tools significant enough to setting up a new environment, that it was worth documenting here with this README.
The first time you run gpg it may or may not create any of the config files and populate them with some options. Most notably `use-keyboxd` is a default option that will frequently appear in `common.conf` these days.

> [!TIP]
> We shouldn't really _need_ to centrally manage our gpg configuration, and for the most part it should be fine to simply mention config settings required for any potential use case if they are ever strictly required to fix something, but other than that, we shouldn't have any need to add them in here.
> _If_ at some point you want to add gpg config files here in the `home` branch expecting this to be used in the style of "`$HOME` is a repo", then to enable a downstream repo submoduling this in the "`$HOME` is another repo" pattern, you will need to either: replace the `rehome` alias with one that sets `CLOBBER_CHECKEDIN_ROOT` to `WARN`; or add the submoduling repo's gpg config in a differently named file and add an alias to replace the `gpg` command with one that provides to it multiple instances of `--options`.

But other than if you choose to clone this repo and use it in that way, we will plan to mostly use the default config.

</details>

## First time setup: Listing keys and configuring git
`gpg --list-keys` will show you a list of known keys. To see all _secret_ keys (with the key ID in the `pub`/`sec`)
```bash
gpg --list-secret-keys --keyid-format=long
# Will print each secret key with a line like ~ i.e.
# sec   <Algo>/<16-char-key-ID> ~ e.g.
# sec   rsa3072/1234567890ABCDEF
gpg --armor --export 1234567890ABCDEF
# Prints the GPG public key, in ASCII armor format
```
From the `sec` line in this for the key we want to use, we take the 16 character key ID and...
```bash
git config --global user.signingkey 1234567890ABCDEF
git config --global commit.gpgsign true
git config --global tag.gpgSign true
git config --global --unset gpg.format # default openpgp
# If you `which gpg` / `where gpg` and get a path you can enter then ~
git config --global gpg.program "<the path you got from which|where gpg>"
```
For examples of the `gpg.program` option across different OS, see the [pre includes README](../.include/.pre/README.md).
## Creating a new key
Creating a new key is simple. All we need is;
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
The main thing we need to consider though, is, depending on what service we want to use the new key with, that some services will have particular requirements for how keys are created, e.g. algorithm strength and key-size. So if you are creating a key specifically for use with a given service, that service will likely have a page documenting how they would expect you to create a key, which might be generic steps, or specific choices in the above selections.

Here are some pages for services that provide key pair generation docs.
* [GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
* [Maven](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair)

## Export/Import a key
A public and or private key can be exported with `--export` + `--armour`|`--armour` to make it base64 readable rather than the otherwise default binary output. Both the default binary stream and the `--armour`'d base64 output can be imported with `--import`. If you are exporting and importing the private key, it includes the public key, so there is no need to do both.

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
## Pin-entry
### Mac
For GPG on Mac you will need both the [GPG](https://formulae.brew.sh/formula/gnupg) brew and the [pinentry-mac](https://formulae.brew.sh/formula/pinentry-mac) brew.

You'll also need to set `~/.gnupg/gpg-agent.conf` to:
```txt
pinentry-program /opt/homebrew/bin/pinentry-mac
```
