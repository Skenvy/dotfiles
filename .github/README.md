<p align="center"><img alt="Banner Image, Dotfiles" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/dotfiles.png" width=1024 height=180/></p>

# [dotfiles@base](https://github.com/Skenvy/dotfiles/tree/base)
See the _main_ [README](https://github.com/Skenvy/dotfiles/blob/main/README.md).

This is the example "base" branch, demonstrating what a repository should look like when following the [Use as "`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles?tab=readme-ov-file#use-as-home-is-another-repo) approach, where this is an example of the repository that includes another repository as a submodule!

<p align="center"><img alt="Banner Image, Dotfiles" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/take_one_for_the_road.png" width=1024 height=180/></p>

You could follow the steps in that [Use as "`$HOME` is _another_ repo"](https://github.com/Skenvy/dotfiles?tab=readme-ov-file#use-as-home-is-another-repo) section to either create these few files from scratch, or you could fork this and just work out of this base branch in your fork.

If you're using this, then you'll want to look at the;
1. [base devcontainer install script](https://github.com/Skenvy/dotfiles/blob/base/install.sh)
    * which does some minor prep before using `main`'s [install.sh](https://github.com/Skenvy/dotfiles/blob/main/install.sh).
1. [base dotfiles-submodule-symlinks-hook](https://github.com/Skenvy/dotfiles/blob/base/.include/dotfiles-submodule-symlinks-hook.sh)
    * which lets us track same-named files as our submodule.

---

This readme makes use of github readme ordering, by default rendering a readme from within the `.github` folder before trying to render one from the repo root; if you are going to create your own copy of this, or fork this, and you want a readme in your copy, you should make it in `.github/README.md`, as the symlinking script will always try to symlink the `main`'s `~/README.md` into your local clone, and wont conflict with one you keep in `.github/README.md`

<p align="center"><img alt="Banner Image, Take one for the road" src="https://raw.githubusercontent.com/wiki/Skenvy/dotfiles/.meta/banners/mi_casa_es_su_casa.png" width=1024 height=120/></p>

## License
> [!NOTE]
> <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Skenvy/dotfiles">dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/Skenvy">Nathan Levett</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC-BY-SA-4.0 <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>
