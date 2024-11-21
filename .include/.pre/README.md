# **Pre** - source / include / hooks
Config files that can be sourced, included, or called as hooks, _**at the end of**_ a config file living in `$HOME`, so that the bulk of the configuration can be checked in, but also provide a way of utilising config that is possibly sensitive or machine|OS-dependent, _or_ not great to have crawlable.
## `.gitconfig`
### Ubuntu
```ini
[core]
    autocrlf = input # Checkout as-is, commit Unix-style
    editor = vim
    filemode = true
    symlinks = true

[gpg]
    program = /usr/bin/gpg
```
### Windows
```ini
[core]
    autocrlf = true  # Checkout Windows-style, commit Unix-style
    editor = <something like '\"C:\\Users\\<username>\\AppData\\Local\\Programs\\Microsoft VS Code\\bin\\code\" --wait' (without '')> 
    filemode = false
    symlinks = false

[gpg]
    program = <???>
```
### MacOS
```ini
[core]
    autocrlf = input # Checkout as-is, commit Unix-style
    editor = vim
    filemode = true
    symlinks = true

[gpg]
    program = /opt/homebrew/bin/gpg
```
