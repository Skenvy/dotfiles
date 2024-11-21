# [Devlog](https://github.com/Skenvy/dotfiles/blob/main/devlog.md)
A wild west of stuff that used to be in the readme, or are notes I wrote for myself. If you got here on an anchor link, that section should be relevant at least.
## Prelim
<!-- don't change the below title, it's anchor linked-to -->
### `$HOME` is a repo
This follows the flat splat pattern of just saying "`$HOME` is a repo".

Rather than cloning into something like `~/dotfiles` and using some `install.sh` script or `stow`, this adopts the pattern that `$HOME` _is_ this repository. The magic, is a `.gitignore` of just `*`, coupled with the intentionality of `git add -f`'ing the files that I want tracked here. Using a subfolder and moving config into it and symlinking that back out to home wouldn't reduce the amount of clutter in `$HOME`, and it doesn't prevent changes from affecting change to the config files in the subfolder, so there's essentially limited to no benefit to using a subfolder and symlinking into `$HOME` (as well as intentionality of adding files to track just transitions from `-f`'ing the `add` to `mv`'ing the file and symlinking it, so there's no less overhead either), especially when I would like to use this across multiple environments that will behave differently with symlinks, including the shadow-realm of being in the context of `wsl` when open on a Windows home folder with this checked out!

This is not a unique pattern, but it's not the most common either. On the [gh dotfile io tutorial](https://dotfiles.github.io/tutorials/) page, [Drew](https://drewdevault.com/)'s [blog post](https://drewdevault.com/2019/12/30/dotfiles.html) appears to be the only example that suggests / outlines this approach, and it's worth a read.

There are however several ways in which this follows a very specifically modified version of the "`$HOME` is a repo" pattern.
### `$HOME` is a repo, _but_ ...
... only if you are cloning this. Later on I discuss a very rigid process of adopting these settings as a submodule, which is antithetical to "`$HOME` is a repo", but provides a methodology of adopting "core" configuration, while also checking in "extended" configuration, by using the `~/.includes/` files. This is primarily done to facilitate use-cases where you want to keep configuration checked in, but it can't or shouldn't be hosted in a public repository.
### `$HOME` is a repo, **and** ...
... extensible, if you're happy to not check-in your _extended_ configuration (by design). You can clone this, following the steps outlined below that describe how to do the initial setup of your local copy, over the top of an existing `$HOME`. Once you have it cloned, it will only track changes to files that are already being tracked, as the `.gitignore` of just `*` allows us to only track what we intentionally forcefully add. That's not the end though. There's places that "extensible" configuration files might look to try and find files that are optionally sourced or to hook-in, if they exist.

You should read both the `~/.include/.pre/README.md` and the `~/.include/.post/README.md` for examples or suggestions of extensions to place in either folder. The first example you might find necessary, for example, is to create an `~/.include/.post/.bashrc` and add a line that does `ssh-add-unloaded-key "Name_of_your_main_ssh_key"`, to have your main ssh key used most frequently loaded. Why not keep something like that in the "core" `~/.bashrc`? Well, on different machines, a different key might be the most frequently used, and if multiple keys that are valid for the same host are added, only the first one that's accepted by a host will be tried for authenticating. So it's easiest across multiple machines that adopt these configs to allow something like that to exist in the "extended" config. Similar reasons exist everything else.

A `#TODO` is to add scripts that generate the recommendations contained in `~/.include/.pre/README.md` and the `~/.include/.post/README.md`, but for now, their recommendations are the expected starting point.
### `$HOME` is _another_ repo
#### Submodule approach
The process of using the `~/.include/` configuration files as a way of extending the "core" configuration, with the expectation of not checking in anything under `~/.include/`, lends itself to the possibility of making use of this repository as a submodule in another repository, and symlinking the contents in this onto `$HOME`. This is discussed in more detail below.
#### Fork approach
This is only a `#TODO` if I ever have to use a windows device for work again, until then, I can't be bothered.
## Adopt these configurations
* If `~` is empty:
```sh
cd ~ && git clone https://github.com/Skenvy/dotfiles.git .
```
* If `~` is _NOT_ empty:
```sh
cd ~ && git init && git remote add origin https://github.com/Skenvy/dotfiles.git && git fetch && cp -r .git/refs/remotes/origin/* .git/refs/heads/ && git remote set-head origin -a && REMOTE_HEAD=$(git name-rev origin/HEAD --name-only) && rm .git/refs/heads/* && git checkout -b $REMOTE_HEAD origin/$REMOTE_HEAD -f
```
* If `~` is _NOT_ empty, and you want to use _only_ `git`:
```sh
cd ~ && git init && git remote add origin https://github.com/Skenvy/dotfiles.git && git fetch && git remote set-head origin -a && HEADSHA=$(git rev-parse origin/HEAD) && git remote set-head origin -d && REMOTE_HEAD=$(git name-rev $HEADSHA --name-only) && git checkout -b main $REMOTE_HEAD -f
```
* If `~` is _NOT_ empty, and you want to use _only_ `git`, and you want to use ssh:
```sh
cd ~ && git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && git remote set-head origin -a && HEADSHA=$(git rev-parse origin/HEAD) && git remote set-head origin -d && REMOTE_HEAD=$(git name-rev $HEADSHA --name-only) && git checkout -b main $REMOTE_HEAD -f
```
* If `~` is _NOT_ empty, you want to use ssh, and force the cutover to these settings:
```sh
rm -rf .git/ && cd ~ && git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && cp -r .git/refs/remotes/origin/* .git/refs/heads/ && git remote set-head origin -a && REMOTE_HEAD=$(git name-rev origin/HEAD --name-only) && rm .git/refs/heads/* && git checkout -b $REMOTE_HEAD origin/$REMOTE_HEAD -f
```
## Use this as a base with your own `.include`'s
To use these configs as an extensible base, where you can track this repository and use its contents, you should add this repository as a submodule in your own dotfiles repository, and symlink its contents into `$HOME`. This lets you use and stay up-to-date with changes to **this**, but also allows you to commit any additional files you need, provided they wont just get symlinked over by following this process.

<!-- don't change the below title, it's anchor linked-to -->
### submodule-original-motivation
> [!IMPORTANT]
> This is specifically geared to my use case of wanting to maintain personal, public, dotfiles that I utilise on personal machines, that I can also utilise on any work machine, for which it would be convenient to use a private repository such that I can commit the `.include/*` hooks relevant for work that shouldn't be public, but that I don't want to lose to the ether. This method allows for maintaining these personal, public, dotfiles, that I can submodule into a private, work specific, dotfiles repository, symlink into `$HOME`, and commit any `.include/*` hooks as they grow.

Of course, this goes against the intentional lack of symlinks in **this** flat splat of the "`$HOME` is a repo" design, but I'm ok with that. You might say that forking this, and tracking **this** as an upstream would be simpler, but that lacks that immediacy of seperation between "what am I editting in 'my changes on top of this'?" and "am I editting something that I'll need to move back upstream?" -- whereas working with a module lets me see the small changeset of hooks for what they are, and immediately know from a `git status` if I need to relocate config changes.

Anyway, here's how you would submodule this into another repository and symlink it into `$HOME`.
1. If you use a `.gitignore` that is just `*`, this can conflict with adding a submodule, so temporarily `rm .gitignore`
1. If you'd like to fork this first, you can, and, say, call it `dotfiles-base`
1. Now you can track this as a submodule `git submodule add git@github.com:Skenvy/dotfiles.git`
1. Or if you forked `git submodule add -- git@github.com:<YOU>/dotfiles-base.git dotfiles`
1. The submodule and `.gitmodules` are staged, so `git restore .gitignore` and commit.
1. `git submodule init && git submodule update`

Now with a `.gitmodules` file that places **this repository** in the `dotfiles` folder in the repo that has added this;
```ini
[submodule "dotfiles"]
        path = dotfiles
        url = git@github.com:Skenvy/dotfiles.git
# OR
[submodule "dotfiles"]
        path = dotfiles
        url = git@github.com:<YOU>/dotfiles-base.git
```
With the submodule initialised and updated we can now symlink its contents into `$HOME`.
> [!CAUTION]
> `CLOBBER_HOME=DESTRUCTIVELY` will **force** symlinks (`ln -sf`) to write over files.
> ```bash
> cd ~ && ./dotfiles/bin/dotfiles-submodule-symlinks # Safest. Or, if you prefer to live on the edge..
> CLOBBER_CHECKEDIN_ROOT=REPLACE CLOBBER_HOME=GRACEFULLY ./dotfiles/bin/dotfiles-submodule-symlinks
> ```

> [!WARNING]
> If you want to maintain a `README.md` that will display on the github page of the repository that submodules this, because this process will clobber the including repository's root `README.md` with a symlink to **this** repository's `README.md`, you can get around this by placing your `README.md` you want displayed at `.github/README.md`, which is the first path for a `README.md` file that github will look for (even before a root `README.md`).

> [!IMPORTANT]
> Note that the process of linking files into `$HOME` wont touch several files, listed in the script. You should ideally have a `~/.gitignore` of just `*` and a `~/.gitattributes` of just `* text=auto`.

## Images in the readme
Images are stored in the wiki and sourced in the html of the readme. `git clone git@github.com:Skenvy/dotfiles.wiki.git`, then you can find the images in `(dotfiles.wiki)/.meta/banners/` and access them via https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/
