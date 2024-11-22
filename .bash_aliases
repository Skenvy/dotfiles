source-existing-file ~/.include/.post/.bash_aliases

alias gg="ls -liath"
alias yellow_brick_road="echo \$PATH | tr ':' '\n'"
alias gsh="perl -nE 'BEGIN {print \"git (CTRL+D to quit)> \"} system \"git \$_\"; print \"git (CTRL+D to quit)> \"'"
# alias start_iterm_from_here="pwd > ~/.iterm2/initdir"

# For using this repo as a submodule
alias rehome="git submodule update --remote && git add dotfiles && CLOBBER_HOME=GRACEFULLY ~/dotfiles/bin/dotfiles-submodule-symlinks && git diff --cached dotfiles && git status"
alias rehome_undo="git restore --staged dotfiles && git restore dotfiles && git submodule update && CLOBBER_HOME=GRACEFULLY ~/dotfiles/bin/dotfiles-submodule-symlinks && git status"

# Git
alias yikes="git log --pretty=format:\"%T | %H | %P\""
alias quack="git diff \$(git merge-base \$(git rev-parse --abbrev-ref origin/HEAD | cut -d/ -f 2) HEAD).. --stat"
alias honk="git diff \$(git merge-base \$(git rev-parse --abbrev-ref origin/HEAD | cut -d/ -f 2) HEAD).."
alias cook_mcangus="CURR_BRANCH=\$(git branch -a | grep \* | cut -d ' ' -f2) && echo \"\\\$CURR_BRANCH = \$CURR_BRANCH\""
alias eat_mcangus="git checkout \$CURR_BRANCH"
alias unhook="git config --unset core.hookspath"
alias gvconf="git config --list --show-origin --show-scope"
alias tracking="git ls-tree --full-tree --name-only -r HEAD"

# Docker
alias yeet="docker run --rm -it ubuntu"
alias bezos="docker run -it --rm amazonlinux bash"
alias MLG="docker run -it --rm fedora bash"
alias snek11="docker run -it --rm python:3.11-slim bash"
alias snek10="docker run -it --rm python:3.10.15-slim bash"
alias snek9="docker run -it --rm python:3.9-slim bash"
alias snek8="docker run -it --rm python:3.8-slim bash"

# Other
alias venv="deactivate 2> /dev/null; python3 -m venv .ve; env; pip3 install --upgrade pip; pip install --upgrade pylama==7.7.1 pylint wheel"
alias env="deactivate 2> /dev/null; source .ve/bin/activate 2> /dev/null"
alias tfff="terraform fmt -check -diff -recursive"
alias hello="cowsay -f dragon Hello"

source-existing-file ~/.include/.post/.bash_aliases
