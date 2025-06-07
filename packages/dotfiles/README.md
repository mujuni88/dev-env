# Dotfiles

My personal dotfiles managed with Dotbot. These configurations work in conjunction with my [Nix configuration](../nix/README.md) to create a complete development environment.

## Structure

```
.
├── bat/          # Syntax highlighting and paging configuration
├── git/          # Git configuration and aliases
├── ghostty/      # Terminal emulator configuration
├── karabiner/    # Keyboard customization for home row mode navigation
├── nvim/         # Neovim configuration and plugins
├── scripts/      # Custom shell scripts and utilities
├── starship/     # Cross-shell prompt configuration
├── tmux/         # Terminal multiplexer configuration
└── zsh/          # Shell configuration and aliases
```

## Prerequisites

- Git
- The specific tools you plan to use (nvim, tmux, etc.)

## Installation

1. Clone the repository if you haven't already:
   ```bash
   git clone <repository_url>
   cd dev-env
   ```

2. Install dotfiles:
   ```bash
   # Complete setup (recommended - includes system dependencies)
   bun run setup
   
   # Dotfiles only
   bun run dotfiles-install
   
   # Direct install (for debugging)
   cd packages/dotfiles && ./install
   ```

The `install.conf.yaml` file controls which files are symlinked where. This setup uses [Dotbot](https://github.com/anishathalye/dotbot) to manage symlinks and installation.

## Managing Configurations

### Adding New Configurations
```bash
# Create new configuration directory
mkdir -p new-tool/.config/new-tool

# Add configuration files to the directory

# Update install.conf.yaml to include the new configuration
# For example:
# - link:
#     ~/.config/new-tool: new-tool/.config/new-tool

# Run the install script to apply changes
./install

# Or use the bun script
bun run sync
```

### Removing Configurations
To remove configurations, either:
1. Comment out or remove the corresponding entries in `install.conf.yaml`
2. Run `./install` or `bun run sync` to apply changes

### Updating After Changes
Whenever you make changes to your dotfiles:
```bash
# Run the install script
./install

# Or using bun
bun run sync
```

### Upgrading Dotbot
To update the dotbot installation to the latest version:
```bash
# Run the upgrade script
./upgrade-dotbot.sh

# Or using npm/bun
bun run upgrade
```

## Tool-Specific Documentation

Each tool's directory contains its own configuration files and may include a README with tool-specific setup instructions and customizations.

## AI Assistant Integration

### Codeium Configuration

[![Codeium](https://img.shields.io/badge/Codeium-AI%20Assistant-blue)](https://codeium.com)

- **Keybindings**:
  - `<C-g>` - Accept suggestion
  - `<C-;>` - Next suggestion
  - `<C-,>` - Previous suggestion
  - `<C-x>` - Clear suggestion
  
- **Security**:
  - API key stored in macOS Keychain
  - Environment variable auto-loaded via zshrc
  - Never stored in plain text
