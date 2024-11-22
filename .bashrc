# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source-existing-file() { if [ -f "$1" ]; then source "$1"; fi; }

source-existing-file ~/.include/.pre/.bashrc

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTIGNORE="*PASSWORD*:*TOKEN*:*API_KEY*:*AWS_ACCESS_KEY_ID*:*AWS_SECRET_ACCESS_KEY*"
# TODO? https://unix.stackexchange.com/questions/210297/how-to-exclude-command-from-history-list-but-to-keep-it-in-live-history

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

##### PS1
# Some rules apply differently to the PS1 compared to other bash variables......
# Dollar expansions happen on the raw text of the PS1's string value. We can set
# PS1='$(call_some_function)' in single quotes, and call_some_function will get
# called dynamically on every prompt. We colour our prompt by setting colours by
# printf'ing the '\e' to get literal ANSI escape 0x1B, and then using the colour
# in the PS1 via something like '\[${COLOUR_NAME}\]' -- as we need to use the \[
# and \] special prompt width commands directly in the prompt not on the colour
# variables, _and_ ${COLOUR_NAME} gets expanded to the bytes of COLOUR_NAME each
# time dynamically, so the ANSI escape 0x1B is preserved.
source-existing-file ~/.bash_formatting

# Add two colours from the 256C that we don't have in the default formatting.
ANSI_ESCFMT_TEXT_256C_129m=$(printf "\e[38;5;129m") # "Purple"
X_256C_TEXT_PURPLE="$ANSI_ESCFMT_TEXT_256C_129m"
ANSI_ESCFMT_TEXT_256C_226m=$(printf "\e[38;5;226m") # "Yellow"
X_256C_TEXT_YELLOW="$ANSI_ESCFMT_TEXT_256C_226m"

# Git branch for prompt
ps1_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Format the appearance of the git branch
ps1_style_git() {
  # If the repo we're in is in $HOME, make it italic. Less visually obvious.
  if [ "$(git rev-parse --show-toplevel)" == "$HOME" ]; then
    style_if_home="$SGR_SET_ITALIC"
  else
    # Do the same italic if we're in a submodule in $HOME.
    if [ "$(git rev-parse --show-superproject-working-tree)" == "$HOME" ]; then
      style_if_home="$SGR_SET_ITALIC"
    fi
  fi
  # If we have a non-empty status, then invert the colours. Visually obvious.
  if [ "$(git status -s)" != "" ]; then
      style_if_status="$SGR_SET_INVERTED"
  else
      style_if_status=""
  fi
  echo "$style_if_home$style_if_status"
}

# $SHLVL for prompt
prompt_shlvl() {
    echo "[${SHLVL}]"
}

# Build any shell options (shopt) we want to display.

# Login shell changes which files are read on bash startup so we care about it!
is_login_shell() {
  shopt -q login_shell && return 0 || return 1
}

# Combine and display all the shopt flags we care to display.
prompt_shopts() {
  flags=""
  flags="$(is_login_shell && echo "L$flags")"
  if [ "$flags" != "" ]; then
    echo "{$flags}"
  else
    echo "{-}"
  fi
}

if [ "$color_prompt" = yes ]; then
# It's nice to keep the rest of the file to shorter lines but our PS1 here is
# going to be using a lot of long var names from ~/.bash_formatting so we're
# looser with how long we care about these lines being..?
PS1='${debian_chroot:+($debian_chroot)}\
\[${SGR_TEXT_GREEN}${SGR_SET_BOLD}\]\u\[${SGR_RESET_DEFAULT}\]@\
\[${SGR_TEXT_GREEN}${SGR_SET_BOLD}\]\h\[${SGR_RESET_DEFAULT}\]:\
\[${SGR_TEXT_BLUE}${SGR_SET_BOLD}\]\w\[${SGR_RESET_DEFAULT}\]:\
\[${XTERM_TEXT_RED}$(ps1_style_git)\]$(ps1_git_branch)\[${SGR_RESET_DEFAULT}\]:\
\[${X_256C_TEXT_YELLOW}\]$(prompt_shlvl)\[${SGR_RESET_DEFAULT}\]:\
\[${X_256C_TEXT_PURPLE}\]$(prompt_shopts)\[${SGR_RESET_DEFAULT}\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w:$(ps1_git_branch):$(prompt_shlvl):$(prompt_shopts)\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# SSH+GPG
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s` > /dev/null
fi

ssh-add-unloaded-key() {
     ssh-add -L | grep "$(cat ~/.ssh/$1.pub)" > /dev/null || ssh-add ~/.ssh/$1
}

# Add a line like the below to your ~/.include/.post/.bashrc
# ssh-add-unloaded-key "my_primary_key"

export GPG_TTY=$(tty)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

source-existing-file ~/.include/.post/.bashrc
