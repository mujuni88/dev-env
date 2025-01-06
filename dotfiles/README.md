# Dotfiles

My personal dotfiles managed with GNU Stow.

## Structure

```
.
├── bat/          # Bat (cat clone) configuration
├── git/          # Git configuration
├── nvim/         # Neovim configuration
├── scripts/      # Custom shell scripts
├── tmux/         # Tmux configuration
├── wezterm/      # Wezterm configuration
└── zsh/          # Zsh configuration
```

## Installation

1. Clone this repository:
```bash
git clone git@github.com:mujuni88/dev-env.git ~/dev-env/dotfiles
```

2. Install GNU Stow:
```bash
brew install stow
```

3. Link the dotfiles:
```bash
cd ~/dev-env/dotfiles
stow -R .
```

Alternatively, you can use any of these aliases (they do the same thing):
- `dots`
- `dotfiles`
- `linkdots`

## Components

- **Zsh**: Shell configuration with organized modules in `~/.config/zsh/`
  - Aliases
  - Completion settings
  - History configuration
  - Key bindings
  - Plugin management

- **Neovim**: Modern Vim configuration with LSP support
- **Tmux**: Terminal multiplexer configuration
- **Wezterm**: Terminal emulator configuration
- **Git**: Git configuration and commit template
- **Bat**: Syntax highlighting configuration for bat
- **Scripts**: Custom utility scripts

## Notes

- Configuration files are organized under `~/.config/` where possible, following the XDG Base Directory specification
- Uses GNU Stow for managing symlinks
- Includes custom aliases for common operations
