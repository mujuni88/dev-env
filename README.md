# Development Environment

This repository contains my personal development environment setup, including:
- Dotfiles (shell, vim, tmux, etc.)
- Nix configuration (macOS system configuration)
- Development tools and scripts

## Documentation

For detailed documentation about configurations and setup, see:
- [Dotfiles Documentation](dotfiles/README.md)
- [Nix Documentation](nix/README.md)

## Quick Start

The main configuration files and directories are:
- `dotfiles/` - Shell, editor, and tool configurations
- `nix/` - System configuration using nix-darwin

For detailed setup instructions and available commands, please refer to the [Dotfiles Documentation](dotfiles/README.md)

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

## Development Environment

This repository contains both the dotfiles and nix configuration for managing my development environment.

### Environment Variables
- `MY_DEV` - Development environment root (`$HOME/dev-env`)
- `MY_NIX` - Nix configuration directory (`$MY_DEV/nix`)

### Aliases

#### Development Environment
- `devenv` - Navigate to the dev-env directory
- `devedit` - Open dev-env in neovim

#### Dotfiles
- `dots` - Navigate to dotfiles and restow all configurations
- `dotsedit` - Open dotfiles in neovim

#### Nix Configuration
- `nixswitch` - Rebuild and switch system configuration (automatically cleans up old generations)
- `nixup` - Update flake inputs and rebuild system
- `nixedit` - Open nix configuration in neovim

## Nix Configuration

This repository includes a Nix-based system configuration for macOS using [nix-darwin](https://github.com/LnL7/nix-darwin). The configuration is located in the `nix/` directory and uses the flakes feature for reproducible builds.

### Structure
- `nix/flake.nix` - Main configuration file
- `nix/modules/` - Module configurations
- `nix/flake.lock` - Dependency lockfile

### Nix Aliases
Quick access to common Nix operations:
- `nixswitch` - Rebuild and switch system configuration (automatically cleans up old generations)
- `nixup` - Update flake inputs and rebuild system
- `nixedit` - Open nix configuration in neovim

### Usage
1. Edit the configuration:
   ```bash
   nixedit
   ```

2. Build and switch to the new configuration:
   ```bash
   nixswitch  # This will also clean up old generations
   ```

3. Update flake inputs and rebuild:
   ```bash
   nixup
   ```

Note: Every time you run `nixswitch` or `nixup`, it automatically cleans up old system generations while keeping the current one as a backup.

## Contributing

Feel free to fork this repository and customize it for your own use. If you have improvements that might benefit others, pull requests are welcome!

## License

This project is open source and available under the MIT License.