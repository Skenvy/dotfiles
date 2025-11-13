source-existing-file ~/.include/.post/.bash_aliases

################################################################################
# Aliases used to proctor updating this repo when it's added as a submodule..
# https://github.com/Skenvy/dotfiles?tab=readme-ov-file#use-as-home-is-another-repo
# You'll need to manually run the dotfiles-submodule-symlinks the first time to
# put the links in place (e.g. link _this_ file in place). But once you've done
# that you can just "rehome" to update the submodule to latest.

# For using this repo as a submodule
alias rehome="git submodule update --remote && git add dotfiles && CLOBBER_HOME=GRACEFULLY ~/dotfiles/bin/dotfiles-submodule-symlinks && git diff --cached dotfiles && git status"
alias rehome_undo="git restore --staged dotfiles && git restore dotfiles && git submodule update && CLOBBER_HOME=GRACEFULLY ~/dotfiles/bin/dotfiles-submodule-symlinks && git status"

################################################################################
# The above are two aliases relevant to using this repoistory as a submodule as
# described by the README. For any additional aliases I use, I've added them
# only in https://github.com/Skenvy/dotfiles/blob/home/.bash_aliases my home.

source-existing-file ~/.include/.post/.bash_aliases
