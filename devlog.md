# [Devlog](https://github.com/Skenvy/dotfiles/blob/main/devlog.md)
> [!CAUTION]
> See ["How to approach reading my devlogs"](https://github.com/Skenvy/Skenvy/blob/main/extra/docs/devlog.md) if you need to.
## Using this repo?
The main README outlines how to _use_ this repo in either of the two supported patterns.
1. [Use as "`$HOME` is _this_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-this-repo)
1. [Use as "`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo)

Here we discuss the motivations that lead to these being what we ended up doing.
<!-- don't change the below title, it's anchor linked-to ~ (./devlog.md#home-is-a-repo) -->
## `$HOME` is a repo
This dotfile repository follows the pattern of just saying "`$HOME` is a repo". We clone directly on top of `$HOME` and track files directly from there.

Rather than cloning into something like `~/dotfiles` and using some custom script or `stow`, this adopts the pattern that `$HOME` _is_ **this** repository.

The magic is a `.gitignore` of just `*`, coupled with the intentionality of `git add -f`'ing (force adding) the files that I want tracked here. Using a subfolder and moving config into it and symlinking / `stow`-ing that back out to `$HOME` wouldn't reduce the amount of clutter in `$HOME`, and it doesn't prevent changes from affecting change to the config files in the subfolder, so there's essentially limited to no benefit to using a subfolder and symlinking into `$HOME` (as well as; the intentionality of adding files to track just transitions from `-f`'ing the `add` to `mv`'ing the file and symlinking it, so there's no less overhead either), especially when I would like to use this across multiple environments that will behave differently with symlinks, including the shadow-realm of being in the context of `wsl` when open on a Windows home folder with this checked out!

This is not a unique pattern, but it's not the most common pattern either. On the [gh dotfile io tutorial](https://dotfiles.github.io/tutorials/) page, [Drew](https://drewdevault.com/)'s [blog post](https://drewdevault.com/2019/12/30/dotfiles.html) appears to be the only example that suggests / outlines this approach, and it's worth a read, as it's what inspired this when I first decided to start crafting what is now a more complicated behemoth than what started out with simple intentions (as you'll learn if you read further).
### Uh oh, we've boiled the frogs...
There are however several ways in which this follows a very specifically modified version of the "`$HOME` is a repo" pattern.
## `$HOME` is a repo, _but_ ...
... only if you are *cloning* this.

Whilst "`$HOME` is a repo" is my primary personal use case, I also want to support the option of *submoduling* these dotfiles into a different dotfile repo.

Why? Because I want the option of using these personal dotfiles as a building block in a private, work specific, dotfile repo. I don't want to have to download and upload the repo to a different remote repo as if this were a template repo, because that would make it more confusing later on to figure out what changes, if any, I had made to this repo, to know what changes to port over to any repos created from this as a template. No, that would just be too cumbersome. Submoduling this repo into another, and making use of various tools' configuration having options that allow them to be extended by additional config files, means that adopting changes made to this repo later on is as simple as just updating the ref of the submodule, and the changes will just drop in to the repo that submodules this one!
### "`$HOME` is _another_ repo"
Of course, building first-class support into this repo to make it easier for another repo to submodule it does involve _boiling some frogs_, because to support this new "`$HOME` is _another_ repo" pattern, we need to reinvent a shittier micro hyper specific version of `stow` just to deal with symlinking files out of the submodule's folder and into `$HOME`. You can see the script that handles this complexity [here](https://github.com/Skenvy/dotfiles/blob/main/bin/dotfiles-submodule-symlinks).

This feels kind of antithetical to our primary goal of being "`$HOME` is a repo", but provides a methodology of adopting "core" configuration in a submodule, while also checking in "extended" configuration, by using the `~/.includes/` files or the `CLOBBER_CHECKEDIN_ROOT_IGNORELIST` script option.

This is primarily done to facilitate use-cases where you want to keep configuration checked in, but it can't or shouldn't be hosted in a public repository e.g. "work specific dotfiles.""
## `$HOME` is a repo, **and** ...
... extensible, if you're happy to hand-wave checking-in your _extended_ configuration.

Of course, you can _clone_ / **fork** / _remake_ this as you see fit, and check-in whatever you want. If you are making your own dotfiles based on these, you don't need to follow this anti-pattern for your own machine-specific config. An alternative would just be to keep a different branch for each machine. For some reason I chose differently. Don't yell at me.

Checking in the files that the core config looks for when trying to "include" extended config wont break anything, and it's what I do in private repos that follow the "`$HOME` is _another_ repo" pattern. But I don't check-in several of these files that include pieces of config required for core tools like git to work properly in this repo's `main` or `home` branch. I do however keep two README's with example blocks that I can copy paste when setting up a new machine.

You should read both the [`~/.include/.pre/README.md`](./.include/.pre/README.md) and the [`~/.include/.post/README.md`](./.include/.post/README.md) for examples or suggestions of extensions to place in either folder.

The first example you might find necessary, for example, is to create an `~/.include/.post/.bashrc` and add a line that does `ssh-add-unloaded-key "Name_of_your_main_ssh_key"`, to have your main ssh key used most frequently loaded. Why not keep something like that in the "core" `~/.bashrc`? Well, on different machines, a different key might be the most frequently used, and if multiple keys that are valid for the same host are added, only the first one that's accepted by a host will be tried for authenticating. So it's easiest across multiple machines that adopt these configs to allow something like that to exist in the "extended" config.
<!-- don't change the below title, it's anchor linked-to ~ (./devlog.md#using-home-is-another-repo) -->
## _Using_ `$HOME` is _another_ repo
Read [Use as "`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo) for how to adopt this repo as a submodule.

This pattern will make use of a [script](./bin/dotfiles-submodule-symlinks) which currently is only written for Ubuntu/Mac.

If you want to use this pattern on a Windows machine, you'll either need to create a PowerShell equivalent of this script, or manually create junctions for each file you want to "windows symlink" from your `~/dotfiles` submodule into your `~/` home.
Here is an attempt copilot had at writing a PowerShell equivalent script, but I have not verified it yet ([chat link](https://github.com/copilot/share/0a6f0224-03e0-8c82-b042-9809808b40c9)).
## Core files for _both_ patterns
### `~/.gitignore`
This one is simple. Ignore _everything_. We don't want to accidentally `git add .`!

When you want to add something, force it with `git add -f <filename>`
```conf
*
```
### `.gitattributes`
We use the following, taken from [[1 (git docs)](https://git-scm.com/docs/gitattributes)] [[2.1 (vsc docs)](https://code.visualstudio.com/docs/devcontainers/tips-and-tricks#_resolving-git-line-ending-issues-in-containers-resulting-in-many-modified-files)] [[2.2 (vsc docs permalink)](https://github.com/microsoft/vscode-docs/blob/499d8d142949f9b55f8731920d942c1baec6779b/docs/devcontainers/tips-and-tricks.md?plain=1#L70-L80)]
```conf
* text=auto eol=lf
*.cmd text eol=crlf
*.bat text eol=crlf
```
If you're adding these later in development remember to `git add --renormalize .` to apply these setting to the indexed state.
<!-- don't change the below title, it's anchor linked-to ~ (./devlog.md#submodule-original-motivation) -->
## submodule-original-motivation
> [!IMPORTANT]
> This is specifically geared to my use case of wanting to maintain personal, public, dotfiles that I utilise on personal machines, that I can also utilise on any work machine, for which it would be convenient to use a private repository such that I can commit the `.include/*` hooks relevant for work that shouldn't be public, but that I don't want to lose to the ether. This method allows for maintaining these personal, public, dotfiles, that I can submodule into a private, work specific, dotfiles repository, symlink into `$HOME`, and commit any `.include/*` hooks as they grow.

Of course, this goes against the intentional lack of symlinks in **this** flat splat of the "`$HOME` is a repo" design, but I'm ok with that. You might say that forking this, and tracking **this** as an upstream would be simpler, but that lacks that immediacy of seperation between "what am I editting in 'my changes on top of this'?" and "am I editting something that I'll need to move back upstream?" -- whereas working with a module lets me see the small changeset of hooks for what they are, and immediately know from a `git status` if I need to relocate config changes.
E.g. if a `git status` tells me I've got a dirty ref in my submodule then I know I need to move automated edits that were made to the files it contains into my `~/.include/*`'s.

## Images in the readme
Images are stored in the _wiki_ and sourced in the html of the readme. You can clone the wiki with `git clone git@github.com:Skenvy/dotfiles.wiki.git`, then you can find the images in `(dotfiles.wiki)/.meta/banners/` and access them via https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/filename e.g. https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/mi_casa_es_su_casa.png

## Adopt these configurations
I eventually settled on recommending [this approach](https://github.com/Skenvy/dotfiles/tree/home?tab=readme-ov-file#clone-my-home)
> [!CAUTION]
> **Destructively** overwrite the files of the same name as those checked in.
> ```bash
> git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && git checkout -b home remotes/origin/home -f
> ```
But I've left these older examples here of what I first suggested using when I first started working on this and wanted to give myself way more options that necessary. They are purely academic examples, and they all `git checkout -b some_branch remotes/origin/some_branch -f` force the checkout so they're _all_ destructive.

Unless there's some easy commands to suggest to verify the contents of a checkout against files that the checkout would overwrite without actually applying the checkout, the initial clone when first setting up these dotfiles on a new machine still requires white-glove-treatment.
<details>
<summary>older examples</summary>

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

</details>
