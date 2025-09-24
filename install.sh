#!/bin/bash
set -euo pipefail

################################################################################
# ____                 ____               _          _                         #
#|  _ \   ___ __   __ / ___| ___   _ __  | |_  __ _ (_) _ __    ___  _ __  ___ #
#| | | | / _ \\ \ / /| |    / _ \ | '_ \ | __|/ _` || || '_ \  / _ \| '__|/ __|#
#| |_| ||  __/ \ V / | |___| (_) || | | || |_| (_| || || | | ||  __/| |   \__ \#
#|____/  \___|  \_/   \____|\___/ |_| |_| \__|\__,_||_||_| |_| \___||_|   |___/#
################################################################################
# https://containers.dev/ ~ https://github.com/devcontainers
################################################################################
# This is the install script used inside of a devcontainer build.
# It is invoked both by VS Code depending on settings.json --
# -- See https://code.visualstudio.com/docs/devcontainers/containers
# -- for both "dotfiles.targetPath" and "dotfiles.installCommand"
# And by GitHub Codespaces depending on https://github.com/settings/codespaces -
# -- https://docs.github.com/en/codespaces/setting-your-user-preferences/\
# -- \personalizing-github-codespaces-for-your-account#dotfiles
# While gh codespaces automatically symlinks ~/.dotfiles/.* if this script
# does not exist, the same fallback behaviour is not present in vs code.
# Supporting this dotfile repo for devcontainers in vsc and ghcs is 1st party.
################################################################################
# The three settings.json are stored here at:
# * Linux: ~/.config/Code/User/settings.json
# * Mac: ~/Library/Application Support/Code/User/settings.json
# * Windows + WSL: ~/AppData/Roaming/Code/User/settings.json
# Note that the Windows settings are what will be applied if triggering a dev
# container build from a vs code opened in Windows connected to the WSL remote,
# which is the behaviour for any `code .`-ish commands run in WSL.
# In these settings, we configure the following:
# * "dotfiles.repository": "git@github.com:Skenvy/dotfiles.git" -- use THIS repo
# * "dotfiles.targetPath": "~/.dotfiles" -- copy repo to THIS folder on build
# * "dotfiles.installCommand": "install.sh" -- run THIS script !!!
################################################################################
# If you are using this repo in the "$HOME is this repo" pattern, then _this_ is
# what will run, either "THIS this" if you didn't change the dotfiles.repository
# settings, or "YOUR this" if you forked this repo and updated those settings.
################################################################################
# If you are using this repo in the "$HOME is another repo" pattern, you'd've
# copied this https://github.com/Skenvy/dotfiles/blob/base/install.sh install --
# which requires some additional setup to have it work against your copy of this
# -- which simply expands the "this repo as a submodule", executes the provided
# "bin/dotfiles-submodule-symlinks" script, _using the script's provided hook_,
# to allow both "THIS this" and "BASE this" <repo-root>/install.sh to co-exist,
# then finally runs "THIS" script after symlinking it from the submodule. The
# _critical_ piece though is that your copy of this repo's base branch has its
# vsc settings set to point to _your copy_ of the base branch.
################################################################################

DOTFILES_DEFAULT="$HOME/.dotfiles" # match this "dotfiles.targetPath" by default
: "${DOTFILES:=$DOTFILES_DEFAULT}" # or let a repo that submodules this set this

printf '#%.0s' {1..80} && echo
echo "# INIT DEVCONTAINERS INSTALL SCRIPT ~(in)> $(pwd)"
printf '#%.0s' {1..80} && echo

# If this is run by a https://github.com/Skenvy/dotfiles/blob/base/install.sh
# duplicate, then it would have already expanded THIS repo as ITS submodule.
echo "Expanding all submodules in $DOTFILES..."
git -C "$DOTFILES" submodule update --init --recursive

# Find all files and links in dotfiles repo and submodules, relative to DOTFILES
find_dotfiles() {
  find "$DOTFILES" -type f,l ! -path "$DOTFILES/.git/*"
}

# We must export this for the `submodule foreach`
export PATCH_DIR="$DOTFILES/patches"
mkdir -p "$PATCH_DIR"
echo "Make diff patch directory $PATCH_DIR for inverse patch logs"

echo "Copying existing home dir files into dotfiles tree for patch logs..."
while IFS= read -r src_file; do
  # Compute relative path from DOTFILES by stripping $DOTFILES from them.
  relative_path="${src_file#$DOTFILES/}"
  home_file="$HOME/$relative_path"
  # We are now in a spot where we have src_file as the path to the file inside
  # $DOTFILES, relative_path as the path sans the $DOTFILES, and home_file the
  # path to the file in $HOME.
  if [ -f "$home_file" ]; then
    echo "-- Temporarily overwrite $home_file to $src_file"
    cp -p "$home_file" "$src_file"
  fi
done < <(find_dotfiles)

# Generate inverse patch logs in $PATCH_DIR ~= "~/.dotfiles/patches/..."
echo "Generate inverse patch logs..."
if [[ -n "$(git -C "$DOTFILES" diff)" ]]; then
  git -C "$DOTFILES" diff -R > "$PATCH_DIR/base.patch"
  echo "-- write inverse patch log $PATCH_DIR/base.patch"
fi
git -C "$DOTFILES" submodule foreach --recursive '
SUBMODULE_PATH="$toplevel/$sm_path" # special vars set by git submodule foreach
# But we dont need this SUBMODULE_PATH because the $(pwd) here is already that!
[ -n "$(git diff)" ] && git diff -R > "$PATCH_DIR/${name}_submodule.patch" && \
echo "-- write inverse patch log $PATCH_DIR/${name}_submodule.patch"
'
# These patch logs will show the diffs for each submodule + base, and are
# inverted, so that they show what diff _we_ are applying on the files that
# already existed and matched the same file names in the container!

echo "Resetting dotfiles repo and submodules..."
git -C "$DOTFILES" reset --hard HEAD
git -C "$DOTFILES" submodule foreach --recursive 'git reset --hard HEAD'

echo "Copying dotfiles to home (overwriting)..."
while IFS= read -r src_file; do
  relative_path="${src_file#$DOTFILES/}"
  home_file="$HOME/$relative_path"
  mkdir -p "$(dirname "$home_file")"
  ln -srf "$src_file" "$home_file"
  echo "-- Create force relative symlink: $relative_path"
done < <(find_dotfiles)

printf '#%.0s' {1..80} && echo
echo "# FINISHED DEVCONTAINERS INSTALL SCRIPT"
printf '#%.0s' {1..80} && echo
