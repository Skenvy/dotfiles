# [devcontainers](https://containers.dev/)
This is only a very minimal example devcontainer, to make this repository able
to self-demonstrate the configuration examples that set "this" repository as the
remote to use when editing "this" repository in vs code, and opening it as
"Reopen in Container".

Selecting to reopen this repository folder in-container from vs code will run
the devcontainer extension, which will look at the vs code configuration
(depending on OS), which will use the "dotfiles.repository" option to target the
remote (GitHub) of this repository, to install in the container when setting it
up, and run the `"dotfiles.installCommand"` script, which here is our
[`"install.sh"`](../install.sh) script.

So this here's [devcontainer.json](./devcontainer.json) is just to demonstrate
that this's [`"install.sh"`](../install.sh) script works properly when setting
up the default suggested image `"mcr.microsoft.com/devcontainers/universal:2"`.
