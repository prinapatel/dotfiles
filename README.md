# dotfiles

Personal dev environment. One repo, one command, identical setup on any Mac.

## What's included

| Config | What it does |
|---|---|
| neovim | Editor — rose-pine dawn, LSP, autocomplete, telescope, git signs |
| zsh | Shell — clean prompt, aliases, uv for Python |
| ghostty | Terminal — rose-pine dawn, JetBrains Mono |
| tmux | Terminal multiplexer — prefix Ctrl+a, rose-pine dawn status bar |
| git | Version control — aliases, conventions (configured per machine) |

## Setting up a new machine

**1. Clone the repo**
```bash
git clone https://github.com/yourusername/dotfiles ~/Code/dotfiles
```

**2. Run the bootstrap script**
```bash
cd ~/Code/dotfiles && ./scripts/bootstrap.sh
```

This installs Homebrew, all packages, uv, symlinks every config into place, and bootstraps neovim plugins. Restart your terminal when it finishes.

**3. Set your git identity**
```bash
git config --global user.name "Your Name"
git config --global user.email "you@wherever.com"
```

That's it.

## Keeping configs in sync

Configs are symlinked from this repo into place — editing them anywhere edits the repo file directly. After any change worth keeping:

```bash
cd ~/Code/dotfiles
git add .
git commit -m "what you changed"
git push
```

On another machine:
```bash
git pull
```

## Adding a new config

1. Create the folder mirroring the target path, e.g. `mkdir -p newapp/.config/newapp`
2. Put the config file inside it
3. Run `stow --target=$HOME newapp`
4. Commit

## Repo structure

```
dotfiles/
├── nvim/.config/nvim/init.lua
├── zsh/.zshrc
├── ghostty/.config/ghostty/config
├── tmux/.tmux.conf
├── git/.gitconfig
├── scripts/
│   └── bootstrap.sh
└── Brewfile
```
