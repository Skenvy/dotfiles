# GPG
> [!NOTE]
> These tips _originally_ started in [this gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0#gpg).
>
> The gist originally dealt with ssh only, so this for gpg is WIP at the moment.
---
These tips are focussed _mostly_ on WSL and Windows _**side-by-side**_. Because that's _my_ home development environment. They started as notes for me to remember the unique flavour of managing multiple ssh keys for multiple GitHub account, and using these keys on both Windows and WSL.

GPG, GNU's [OpenPGP](https://www.openpgp.org/), uses `~/.gnupg` as the default home directory which contains a `gpg.conf` and `common.conf` for user config plus any other files in `~/.gnupg/*` for an internal store. See [this](https://docs.github.com/en/authentication/managing-commit-signature-verification). GPG should be easy to setup in WSL. You can install a Windows release for it from [gnupg downloads](https://www.gnupg.org/download/).
## Symlink setup
WSL doesn't currently have anything that matches `/etc/skel/.gnupg/*`, so for WSL's perpective, we'd need to make these files ourselves if we care to. However, Windows installations of GPG use `~/AppData/Roaming/gnupg/*`. We could theoretically support a "single point of config" by symlinking our Windows `~/AppData/Roaming/gnupg/*` to WSL `~/.gnupg/*`, and this would be the simplest way to have both be aware of the same keys.
## Creating a new key
