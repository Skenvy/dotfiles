# [dotfiles](https://github.com/Skenvy/dotfiles)
[Dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) -- [[topic](https://github.com/topics/dotfiles)] [[io](https://dotfiles.github.io/)] [[codespaces](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles)].
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
cd ~ && git init && git remote add origin https://github.com/Skenvy/dotfiles.git && git fetch && git remote set-head origin -a && HEADSHA=$(git rev-parse origin/HEAD) && git remote set-head origin -d && REMOTE_HEAD=$(git name-rev $HEADSHA --name-only) && git checkout -b trunk $REMOTE_HEAD -f
```
