# **Post** - source / include / hooks
> [!IMPORTANT]
> Config files that can be sourced, included, or called as hooks, _**at the end of**_ a config file living in `$HOME`, so that the bulk of the configuration can be checked in, but also provide a way of utilising config that is possibly sensitive or machine|OS-dependent, _or_ not great to have crawlable.

> [!WARNING]
> Some of the examples here might only be relevant to this's [`home`](https://github.com/Skenvy/dotfiles/tree/home) and not part of this's [`main`](https://github.com/Skenvy/dotfiles/tree/main)
## `.bashrc`-example
The included `.bashrc` file has a function `ssh-add-unloaded-key`, but doesn't add any ssh key itself. Rather, you should add a `.bashrc` file here, under `~/.include/.post/`, that uses this function with the name of your primary ssh key e.g.
```bash
ssh-add-unloaded-key "Name_of_your_main_ssh_key"
```
## `.gitconfig`
### Non-OS dependent
```ini
[user]
    email = <???>
    name = <???>
    signingkey = <???>

[commit]
    gpgsign = true
    signingkey = <???>
```
