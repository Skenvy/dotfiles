<p align="center"><img alt="Banner Image, Dotfiles" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/dotfiles.png" width=1024 height=180/></p>

# [dotfiles](https://github.com/Skenvy/dotfiles)
> [!TIP]
> Proctor your user settings `~/.*` | `$HOME` with
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) --
[topic](https://github.com/topics/dotfiles),
[io](https://dotfiles.github.io/),
[codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles),
[devcontainers](https://containers.dev/),
["awesome"](https://github.com/webpro/awesome-dotfiles)

_This_ is _**my**_ dotfile repository. It follows the ["`$HOME` is a repo"](./devlog.md#home-is-a-repo) pattern. See the [devlog](./devlog.md) for more.
<!-- We can link to anchors in this README via either (./README.md#header-text)
OR (https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#header-text)
We prefer the second format, because it lets the GitHub page just move to it -->

> [!NOTE]
> You can find more detailed instructions below on how to adopt any of these patterns.
> 1. [Use as "`$HOME` is _this_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-this-repo)
> 1. [Use as "`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo)
>
> While this repo's `main` branch represents the core files for "`$HOME` is a repo", [GitHub Codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles) only allow you to use the _default_ branch in a dotfiles repository, so my personal settings in my `home` branch are the default branch here (for use with Codespaces), but `main` is still perfectly viable.

This dotfile repository is setup in a way that it follows ["`$HOME` is a repo"](./devlog.md#home-is-a-repo), in multiple ways.
1. "`$HOME` is _this_ repo" -- you can directly clone this on top of `$HOME`.
    1. You can *clone* this's [`home`](https://github.com/Skenvy/dotfiles/tree/home) (_my_ config, if you want the exact same config)
    1. You can **fork** this's [`main`](https://github.com/Skenvy/dotfiles/tree/main) (the core files for my "`$HOME` is a repo" setup)
    1. You can **fork** this's [`home`](https://github.com/Skenvy/dotfiles/tree/home) (_my_ config, if you want to start from but change it)
1. "`$HOME` is _another_ repo" -- you add this as a submodule in your own dotfiles repository ~= `$HOME`.
    1. You can _clone_ / **fork** / _remake_ this's [`base`](https://github.com/Skenvy/dotfiles/tree/base) and target this's [`main`](https://github.com/Skenvy/dotfiles/tree/main) or [`home`](https://github.com/Skenvy/dotfiles/tree/home)
    1. You can _clone_ / **fork** / _remake_ this's [`base`](https://github.com/Skenvy/dotfiles/tree/base) and target your **fork** of this's [`main`](https://github.com/Skenvy/dotfiles/tree/main) / [`home`](https://github.com/Skenvy/dotfiles/tree/home)

> [!IMPORTANT]
> _My_ use cases are a combination of
> 1. For personal machines
>     1. "`$HOME` is _this_ repo" :: "*clone* this's [`home`](https://github.com/Skenvy/dotfiles/tree/home)"
> 1. For work machines I do both of
>     1. "`$HOME` is _this_ repo" :: "**fork** this's [`home`](https://github.com/Skenvy/dotfiles/tree/home)" to my work account [CloutKhan/dotfiles-base](https://github.com/CloutKhan/dotfiles-base)
>     1. "`$HOME` is _another_ repo" :: "_remake_ this's [`base`](https://github.com/Skenvy/dotfiles/tree/base) and target your fork of this's [`home`](https://github.com/Skenvy/dotfiles/tree/home)"

> [!TIP]
> The other provided use cases allow you to do the exact same thing, but with an emphasis on keeping your own forks of everything, in every case. I like what I've done here, but fundamentally dotfiles are "personal" configuration, so if you do like this pattern, you should fork it, because there's no guarantee I won't completely change this at any point. This's [`main`](https://github.com/Skenvy/dotfiles/tree/main) is an example of the setup, with some essentially unchanged config files as examples only. This's [`home`](https://github.com/Skenvy/dotfiles/tree/home) is the actual settings I use. If you kinda like the idea of this, but that's it, the [`main`](https://github.com/Skenvy/dotfiles/tree/main) branch's init commit contains the actual core files. Idk do what you want lol.

<p align="center"><img alt="Banner Image, Bless this mess" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/bless_this_mess.png" width=1024 height=180/></p>

## Pre-use
> [!TIP]
> You will only strictly _need_ `git`. But you should also setup `ssh` and `gpg`.
>
> You don't _need_ to install `docker` but probably want to. These dotfiles support [devcontainers](./install.sh) as first-class.
>
> You _should_ read and understand the use of the [`~/.include/*`](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#include) methodology.
>
> If you're submoduling this repository, you should understand the [script](./bin/dotfiles-submodule-symlinks) that supports this pattern.
### `git`
To use any approach, you'll need to have `git` installed. See [git downloads](https://git-scm.com/downloads).
### [`ssh`](./.ssh/README.md)
Unless you swap the `ssh` remote in these instructions with the `https` remote, you'll also need `ssh`.

You'll need to have the `ssh-agent` running, and your key added to the agent, and uploaded to GitHub.

See [my SSH README](./.ssh/README.md) for steps on how to handle setting up `ssh` on Ubuntu or Windows (pay close attention to the step for setting `"GIT_SSH"` if you're on Windows). If you already have `ssh` setup, then you're ready to continue to one of the below steps!
### [`gpg`](./.gnupg/README.md)
This is not a requirement for cloning and using this repository or following any of the further instructions, but if you are setting up a new machine for the first time, then [my GPG README](./.gnupg/README.md) might be worth a look, and is worth suggesting in the same tier as `git` and `ssh` being the three standard core programs for secure use of `git`, and being supported for use with devcontainers and codespaces.
### `docker`
You don't need this to use these, but you probably _want_ to install [docker](https://www.docker.com/) and a devcontainer extension for your IDE (e.g. [vs code devcontainers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).

These dotfiles support [devcontainers](./install.sh) as first-class.

If you're using this as ["`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo) then you'll want to look at the;
1. [base devcontainer install script](https://github.com/Skenvy/dotfiles/blob/base/install.sh)
1. [base dotfiles-submodule-symlinks-hook](https://github.com/Skenvy/dotfiles/blob/base/.include/dotfiles-submodule-symlinks-hook.sh)
### `~/.include/*`
> [!IMPORTANT]
> A critical feature that underpins all approaches to using these dotfiles effectively, you should be aware of this directory. Different config files are allowed to independently expect or optionally hook various files that should or must be kept under `~/.include/*`. They provide a means for "core" or "centralised" or "shared" configuration to be kept in this repository, but also allows "extensible" configuration files, that are "core" files with the ability to seek out "extension" configuration files, that needn't or shouldn't be checked-in here. "Extensible" just means files that can attempt to parse other files in `~/.include/*` and will composite or allow overwriting of "core" (checked-in here) config, by the "extension" configuration files that you will have to maintain in `~/.include/*`.

> [!TIP]
> See both [`~/.include/.pre/README.md`](./.include/.pre/README.md) and [`~/.include/.post/README.md`](./.include/.post/README.md) for the two most commonly parsed folders, that provide suggestions on what config files to add in either place. For an illustrative example of this, have a look at [how to add your ssh key setup to `.bashrc`](./.include/.post/README.md#bashrc-example).

### `dotfiles-submodule-symlinks`
The [script](./bin/dotfiles-submodule-symlinks) that enables the ["`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo) pattern documents all of its inputs.

> [!IMPORTANT]
> What is worth mentioning here, that is only described without example in the script, is how to make use of `CLOBBER_CHECKEDIN_ROOT_IGNORELIST`. If you do not set this, then the default `CLOBBER_CHECKEDIN_ROOT` will error if you have the same file path checked in in both this repository and the repository that submodules it.
>
> So, if you want to check-in a file in your repository that will include this as a submodule, that matches a file that already exists in this repo, and you want the supporting script to ignore the file from _this_ repository and leave your repo's file as is without complaining about the collision, you will need to set `CLOBBER_CHECKEDIN_ROOT_IGNORELIST`.
>
> The quickest way to achieve this is to have an `.include/dotfiles-submodule-symlinks-hook.sh` file checked-in in your repository similar to the [base dotfiles-submodule-symlinks-hook](https://github.com/Skenvy/dotfiles/blob/base/.include/dotfiles-submodule-symlinks-hook.sh).
>
> The main use case for this is to support an `~/install.sh` script in both this repository and one that submodules it, as well as [gpg config files](https://github.com/Skenvy/dotfiles/tree/main/.gnupg#dotfiles).

<p align="center"><img alt="Banner Image, Homeward Bound" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/homeward_bound.png" width=1024 height=180/></p>

## Use as "`$HOME` is _this_ repo"
If you're planning to accept this repository into your `$HOME`, you're doing so aware that these steps will destructively replace files of the same name that exist in your `$HOME` already.

You would typically be interested in following this step as one of the first things you do setting up a new machine, so the destructivity would be limited to only replacing the user files that the system had generated for you. If you're following this step at some other point well after you've been using your machine for a while, chances are that customisations and personal settings might have crept in to your local dotfiles.

If that is the case, you should try your best to extract whatever `diff` there is between your existing config and what's in here, and keep it under `~/.include/`. Alternatively, you could back up your existing config just in case, as an optional step listed in the below.

If you're going to just _clone_ this, then you wouldn't be able to checkin your `~/.include/*`'s, but if you **fork** this, you can checkin you `~/.include/*`'s.
### Steps
More than likely, `~` won't be empty, so `git` will refuse to clone into it.
1. If you have pre-existing checkout here, remove it; `rm -rf .git/`
1. Be in your home directory; `cd` works differently across `bash`, `pwsh`, and `cmd`
1. Make `~` the repo, add the remote, and set the head. ONLY `bash` or `cmd`, NOT `pwsh`.

#### Clone my [`home`](https://github.com/Skenvy/dotfiles/tree/home)
> [!CAUTION]
> **Destructively** overwrite the files of the same name as those checked in.
> ```bash
> git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && git checkout -b home remotes/origin/home -f
> ```

#### Or, fork my [`main`](https://github.com/Skenvy/dotfiles/tree/main) / [`home`](https://github.com/Skenvy/dotfiles/tree/home) and clone your fork
[Fork this](https://github.com/Skenvy/dotfiles/fork), calling it `dotfiles`, and edit the following to point you `<YOU>`.
> [!CAUTION]
> **Destructively** overwrite the files of the same name as those checked in.
> ```bash
> git init && git remote add origin git@github.com:<YOU>/dotfiles.git && git fetch
> # Use only the core set on main
> git checkout -b main remotes/origin/main -f
> # Use and extend my home settings
> git checkout -b home remotes/origin/home -f
> ```

<p align="center"><img alt="Banner Image, Home away from Home" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/home_away_from_home.png" width=1024 height=120/></p>

## Use as "`$HOME` is _another_ repo"
> [!WARNING]
> This pattern currently only works for Ubuntu/Mac. See why in the [devlog](./devlog.md#using-home-is-another-repo).

If you would like to utilise the configurations here as a base, but also be able to add and track your own `.include` files, then adding this as a submodule is what you want.
Using submodules, you can include and refer to this dotfiles repository inside of _another_ dotfiles repo, where you can track this repository and use its contents without ending up with a cluttered repository, while also maintaining your own `.include` files, as well as checking them in, whether for a public or private dotfiles repo.

If this sounds like something you want to try, you should add this repository as a submodule in your own dotfiles repository, and symlink its contents into `$HOME` (a script to do the linking is provided). This lets you use and stay up-to-date with changes to **this**, but also allows you to commit any additional files you need, provided they wont just get symlinked over by following this process. To read about what originally motivated me to provide two seemingly antithetical ways of consuming this repo, [see this](./devlog.md#submodule-original-motivation).
### Steps
#### Starting without a repository
If you do not yet have a dotfiles repository, and this is the way you intend to start one for the first time, or starting over, there's a few things to take note of.
Notably, some files "can't" be symlinked, in that the programs that read them won't be happy following symlinks, e.g. certain `git` configuration for example can't by symlinked as `git` won't follow symlinks.

You'll need to create a new repository that should match this's [`base`](https://github.com/Skenvy/dotfiles/tree/base). If you'd rather fork this and work out of your clone of your fork in this's [`base`](https://github.com/Skenvy/dotfiles/tree/base) branch, that's fine too, but it should be easier to just put together the handful of files.

To begin your repository, you may start with a blank repository, and add two files;
1. `.gitignore` of just `*`
1. `.gitattributes` of just `* text=auto` _or_ more extensively [this's `.gitattributes`](https://github.com/Skenvy/dotfiles/blob/main/.gitattributes) ([devlog](./devlog.md#home-is-a-repo))

Which assumes that you will be only ever "force adding" with `git add -f`, and that you won't be checking in anything other than text files. These both exist in this repository with the same content, but they will be ignored by the symlinking script.

Now you have an "existing repository" with `.gitignore` and `.gitattributes`, follow the next steps.
#### Starting from an existing repository
Here's how you would submodule this into another repository and symlink it into `$HOME`, whether you are submoduling **this** repo, or if you forked it and you're submoduling _your fork_.
1. If you use a `.gitignore` that is just `*`, this can conflict with adding a submodule, so temporarily `rm .gitignore`
1. If you'd like to fork this first, you can, and, say, call it `dotfiles-base`
1. Now you can track this as a submodule `git submodule add git@github.com:Skenvy/dotfiles.git`
1. Or if you forked `git submodule add -- git@github.com:<YOU>/dotfiles-base.git dotfiles`
1. The submodule and `.gitmodules` are staged, so `git restore .gitignore` and commit.
1. `git submodule init && git submodule update`
1. \+ `git submodule update --remote` to periodically retrack your modules's `HEAD`

Now with a `.gitmodules` file that places **this repository** in the `dotfiles` folder in the repository that has added this;
```ini
# If you submodulesd this directly --
[submodule "dotfiles"]
    path = dotfiles
    url = git@github.com:Skenvy/dotfiles.git
    branch = main # or home
# Or if you forked this and submoduled your fork of this --
[submodule "dotfiles"]
    path = dotfiles
    url = git@github.com:<YOU>/dotfiles-base.git
    branch = home
```
With the submodule initialised and updated we can now symlink its contents into `$HOME`.

Remember to read the above section on [dotfiles-submodule-symlinks](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#dotfiles-submodule-symlinks) to understand how to manage the case of checking-in a file to the repository that submodules this one where the file matches a file path that already exists in this repository without having to set `CLOBBER_CHECKEDIN_ROOT` to its most destructive option of `REPLACE`.
> [!CAUTION]
> `CLOBBER_HOME=DESTRUCTIVELY` will **force** symlinks (`ln -sf`) to write over files.
> ```bash
> cd ~ && ./dotfiles/bin/dotfiles-submodule-symlinks # Safest.
> # Or, if you prefer to live dangerously on the edge.. (you have been warned!)
> CLOBBER_CHECKEDIN_ROOT=REPLACE CLOBBER_HOME=GRACEFULLY ./dotfiles/bin/dotfiles-submodule-symlinks
> ```

> [!WARNING]
> If you want to maintain a `README.md` that will display on the github page of the repository that submodules this, because this process will clobber the including repository's root `README.md` with a symlink to **this** repository's `README.md`, you can get around this by placing your `README.md` you want displayed at `.github/README.md`, which is the first path for a `README.md` file that github will look for (even before a root `README.md`).

> [!IMPORTANT]
> Note that the process of linking files into `$HOME` wont touch several specific files, listed in the script. You should ideally have a `~/.gitignore` of just `*` and a `~/.gitattributes` of just `* text=auto` _or_ more extensively [this's `.gitattributes`](https://github.com/Skenvy/dotfiles/blob/main/.gitattributes) ([devlog](./devlog.md#home-is-a-repo)).

<p align="center"><img alt="Banner Image, Take one for the road" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/mi_casa_es_su_casa.png" width=1024 height=120/></p>

## License
> [!NOTE]
> <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Skenvy/dotfiles">dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/Skenvy">Nathan Levett</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC-BY-SA-4.0 <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>
