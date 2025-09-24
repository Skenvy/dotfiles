#!/bin/bash
set -euo pipefail

# THIS is what will run when THIS repo is set as your devcontainers dotfiles.
# See https://github.com/Skenvy/dotfiles/blob/main/install.sh for more info.

# E.g. setting the "dotfiles.*" settings in any of -- 
# The three settings.json are stored here at:
# * Linux: ~/.config/Code/User/settings.json
# * Mac: ~/Library/Application Support/Code/User/settings.json
# * Windows + WSL: ~/AppData/Roaming/Code/User/settings.json

# I.e. you need the "dotfiles.*" in your vsc user settings in this repo to be
# pointing to YOUR copy of this base branch. This is an example, and in the
# case of this, the "dotfiles.repository" is just this repo. You'll need to
# change this setting to your fork.

# THIS should match https://github.com/Skenvy/dotfiles/blob/base/install.sh
# Which will first expand the submodule of your <this-repo>/.gitmodules

# You'll also need the .include/dotfiles-submodule-symlinks-hook.sh config
# provided here as an example, to set "this" "install.sh" in the ignore list
# used by the dotfiles-submodule-symlinks -- CLOBBER_CHECKEDIN_ROOT_IGNORELIST

printf '#%.0s' {1..80} && echo
echo "# INIT DEVCONTAINERS INSTALL SCRIPT -- BASE PRE-EXPANDER & SYMLINKER"
printf '#%.0s' {1..80} && echo

export DOTFILES="$HOME/.dotfiles"

echo "Expanding all submodules in $DOTFILES..."
git -C "$DOTFILES" submodule update --init --recursive

cd "$DOTFILES" && echo "Executing the bin/dotfiles-submodule-symlinks magic"
# Relies on the .include/dotfiles-submodule-symlinks-hook.sh to allow this and
# the submodule's install.sh scripts to co-exist with default invoke settings.
# Except for -- use EXECUTION_CONTEXT as TEST to allow running this inside the
# non $HOME initial checkout of ~/.dotfiles
EXECUTION_CONTEXT=TEST ./dotfiles/bin/dotfiles-submodule-symlinks

# Now we can resume with the base install.sh...
# But it won't copy over THIS file, thanks to dotfiles-submodule-symlinks-hook
cd ~ && ./.dotfiles/dotfiles/install.sh
