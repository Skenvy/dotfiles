# **Post** - source / include / hooks
> [!IMPORTANT]
> Config files that can be sourced, included, or called as hooks, _**at the end of**_ a config file living in `$HOME`, so that the bulk of the configuration can be checked in, but also provide a way of utilising config that is possibly sensitive or machine|OS-dependent, _or_ not great to have crawlable.

> [!WARNING]
> Some of the examples here might only be relevant to this's [`home`](https://github.com/Skenvy/dotfiles/tree/home) and not part of this's [`main`](https://github.com/Skenvy/dotfiles/tree/main)

> [!IMPORTANT]
> All these files described here would appear in your `~/.include/.post/`
## `.bashrc`
The included `~/.bashrc` file has a function `ssh-add-unloaded-key`, but doesn't add any ssh key itself. Rather, you should add a `.bashrc` file here that uses this function with the name of your primary ssh key e.g.
```bash
ssh-add-unloaded-key "Name_of_your_main_ssh_key"
```
## `.gitconfig`
### Non-OS dependent
See the [GPG README](../../.gnupg/README.md) for instructions on setting the `signingkey`.
```ini
[user]
    email = <???>
    name = <???>
    signingkey = <???>

[commit]
    gpgsign = true

[tag]
    gpgSign = true
```
## `.ssh_config`
The `~/.ssh/config` includes `../.include/.post/.ssh_config`. You can keep config in `~/.ssh/config`, but additions to this **post** includes config **wont** act as overrides. You should use this inclusion if you have globbed `Host`'s in either the **pre** includes or the core config, that set some config across a wide glob, if you want to then add more specific config here, that sets previously unset config but on a more granular `Host`.
