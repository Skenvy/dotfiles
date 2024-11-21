# [MacOS _specific_ dotfiles](https://github.com/Skenvy/dotfiles/tree/main/.MacOS)
## [Homebrew](https://brew.sh/)
* See the brews at [~/.MacOS/Brewfile](https://github.com/Skenvy/dotfiles/blob/main/.MacOS/Brewfile).
* Restore brews
    * `brew bundle --file=~/.MacOS/Brewfile`
* Backup brews
    * `brew bundle dump --file=~/.MacOS/Brewfile --force`
* Occasionally necessary fix to outdated Xcode Command Line Tools;
    * `sudo rm -rf /Library/Developer/CommandLineTools && sudo xcode-select --install`
* See the [lockfile](https://github.com/Homebrew/homebrew-bundle/pull/552) at [~/.MacOS/Brewfile.lock.json](https://github.com/Skenvy/dotfiles/blob/main/.MacOS/Brewfile.lock.json) if necessary.
## [iTerm2](https://iterm2.com/)
These settings expect [cowsay](https://formulae.brew.sh/formula/cowsay) to already be installed.

Profiles exported to [`~/.MacOS/iterm_export/Profiles.json`](https://github.com/Skenvy/dotfiles/blob/main/.MacOS/iterm_export/Profiles.json)
> Settings -> Profiles -> "Other Actions..." -> "Import JSON Profiles..."

Full manual _non-anonymised_ preferences backup (including _profiles_ **and** _arrangments_) exported to [`~/.MacOS/iterm_export/com.googlecode.iterm2.plist`](https://github.com/Skenvy/dotfiles/blob/main/.MacOS/iterm_export/com.googlecode.iterm2.plist)
> Settings -> General -> Preferences -> "Load preferences from a custom folder or URL" -> (browse to directory containing this folder) -> "Save changes" -> (Manually)
## [iStat Menus](https://bjango.com/mac/istatmenus/)
From the [App Store](https://apps.apple.com/us/app/istat-menus/id1319778037). Followed by [iStat Menus Helper](https://bjango.com/mas/istatmenus/helper/). See [Bjango's GitHub page](https://github.com/bjango) if you'd like. Then just run the [`~/.MacOS/iStat_Menus_Settings.ismp`](https://github.com/Skenvy/dotfiles/blob/main/.MacOS/iStat_Menus_Settings.ismp) file.
