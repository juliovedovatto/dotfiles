# dotfiles

Personal dotfiles backup and synchronization repository for Julio Vedovatto's macOS setup. This repository contains custom oh-my-zsh configurations and an oh-my-posh prompt theme. These files are intended to be copied or symlinked into $HOME.

> **Note:** the `home/` directory is a mirror of the user's `$HOME`. Files follow their real placement, e.g. `home/.config/oh-my-posh/theme.json` maps to `~/.config/oh-my-posh/theme.json`.

## Oh My Posh

Oh My Posh was designed to use Nerd Fonts. Nerd Fonts are popular fonts that are patched to include icons. To see the icons displayed in Oh My Posh, install a Nerd Font, and configure the terminal to use it:

```sh
brew install --cask font-meslo-lg-nerd-font
```

## Oh My Zsh

The custom shell config (`home/oh-myzsh/custom/aliases.zsh`) ships aliases backed by external tools — some have requirements:

- `lsd` — backer of the `ls`, `ll`, `la`, `l`, and `lt` aliases:
  - install: `brew install lsd`
