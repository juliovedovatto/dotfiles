# dotfiles

Personal dotfiles backup and synchronization repository for Julio Vedovatto's macOS setup. This repository contains custom oh-my-zsh configurations and an oh-my-posh prompt theme. These files are intended to be copied or symlinked into $HOME.

> **Note:** the `home/` directory is a mirror of the user's `$HOME`. Files follow their real placement, e.g. `home/.config/oh-my-posh/theme.json` maps to `~/.config/oh-my-posh/theme.json`.

## Oh My Posh

Oh My Posh was designed to use Nerd Fonts. Nerd Fonts are popular fonts that are patched to include icons. To see the icons displayed in Oh My Posh, install a Nerd Font, and configure the terminal to use it:

```sh
brew install --cask font-meslo-lg-nerd-font
```

> **Note (macOS):** Apple's system bash can't run oh-my-posh's init script. Install Homebrew's bash and make it your login shell:

```sh
brew install bash
chsh -s /opt/homebrew/bin/bash   # Apple Silicon; /usr/local/bin/bash on Intel
```

## Oh My Zsh

oh-my-zsh is mandatory for the prompt setup — the oh-my-posh theme and the custom aliases in `home/oh-myzsh/custom/` assume it. The custom shell config (`home/oh-myzsh/custom/aliases.zsh`) ships aliases backed by external tools — some have requirements:

- `lsd` — backer of the `ls`, `ll`, `la`, `l`, and `lt` aliases:
  - install: `brew install lsd`

## Apple Terminal

Apple Terminal does not read files from `~/.config` — its profiles live in `com.apple.Terminal.plist`. The repo ships a matching profile instead: `macos/Terminal/Custom.terminal` mirrors the Ghostty look (MesloLGM Nerd Font @ 14, `#282c34` background at 0.9 opacity with blur, vertical blinking cursor). Import it and set it as the default:

```sh
open macos/Terminal/Custom.terminal
osascript \
  -e 'tell application "Terminal" to set default settings to settings set "Custom"' \
  -e 'tell application "Terminal" to set startup settings to settings set "Custom"'
```

oh-my-posh still forces 256-color output whenever it sees `TERM_PROGRAM=Apple_Terminal`, even though Tahoe's Terminal supports truecolor. The shipped `home/.zshrc` spoofs the variable to keep the exact theme hexes:

```sh
[[ $TERM_PROGRAM == "Apple_Terminal" ]] && export TERM_PROGRAM=AppleTerminalTC
```

Re-import after changing the profile; deleting the previously imported one first avoids `Custom (1)` duplicates.
