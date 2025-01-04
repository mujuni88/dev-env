# Development Environment

My dotfiles and development environment configuration managed with GNU Stow. This repository contains a curated set of configurations for various development tools, creating a powerful and consistent development environment.

## Components

### Terminal & Shell
- **[WezTerm](https://github.com/wez/wezterm)** (`wezterm/`) 
- **[Zsh](https://github.com/zsh-users/zsh)** (`zsh/`) 
- **[Tmux](https://github.com/tmux/tmux)** (`tmux/`) 

### Development Tools
- **[Neovim](https://github.com/neovim/neovim)** (`nvim/`): 
  - Located in `.config/nvim/`
  - Includes custom keybindings, plugins, and IDE-like features
- **[Git](https://github.com/git/git)** (`git/`): 
  - Global git settings and aliases
  - Includes useful shortcuts and default configurations
- **[Bat](https://github.com/sharkdp/bat)** (`bat/`): Cat clone with syntax highlighting
  - Syntax highlighting and paging configuration
  - Theme settings

### Scripts
- **Custom Scripts** (`scripts/`): Collection of utility scripts for development workflow

## Structure

```
dev-env/
└── dotfiles/
    ├── nvim/
    │   └── .config/nvim/      --> ~/.config/nvim/
    ├── wezterm/
    │   └── .config/wezterm/   --> ~/.config/wezterm/
    ├── git/
    │   └── .gitconfig         --> ~/.gitconfig
    ├── zsh/
    │   └── .zshrc            --> ~/.zshrc
    ├── tmux/
    │   └── .tmux.conf        --> ~/.tmux.conf
    ├── bat/
    │   └── .config/bat/      --> ~/.config/bat/
    └── scripts/              --> ~/bin/
```

## Prerequisites

- GNU Stow (for managing symlinks)
- Git
- Zsh
- Other tools you plan to use (nvim, tmux, wezterm, bat)

## Setup

1. Clone this repository:
```bash
git clone git@github.com:yourusername/dev-env.git
cd dev-env
```

2. Install GNU Stow:
```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow
```

3. Create symlinks:
```bash
# Stow individual configs
cd dotfiles
stow -v -t ~ nvim      # Only neovim config
stow -v -t ~ wezterm   # Only wezterm config
stow -v -t ~ git       # Only git config
stow -v -t ~ zsh       # Only zsh config

# Or stow everything at once
cd ..
stow -v -t ~ dotfiles
```

## Remove Symlinks

```bash
# Remove individual configs
cd dotfiles
stow -D -t ~ nvim     # Remove neovim config

# Or remove everything
cd ..
stow -D -t ~ dotfiles
```

## Customization

Each tool's configuration can be customized by editing the respective files in their directories. After making changes, the symlinks will automatically reflect the updates.

## Contributing

Feel free to fork this repository and customize it for your own use. If you have improvements that might benefit others, pull requests are welcome!

## License

This project is open source and available under the MIT License.