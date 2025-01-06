# Dotfiles

My personal dotfiles managed with GNU Stow. These configurations work in conjunction with my [Nix configuration](../nix/README.md) to create a complete development environment.

## Structure

```
.
├── bat/          # Syntax highlighting and paging configuration
├── git/          # Git configuration and aliases
├── karabiner/    # Keyboard customization for macOS
├── nvim/         # Neovim configuration and plugins
├── scripts/      # Custom shell scripts and utilities
├── tmux/         # Terminal multiplexer configuration
├── wezterm/      # Terminal emulator configuration
└── zsh/          # Shell configuration and aliases
```

## Prerequisites

- GNU Stow (for managing symlinks)
- Git
- The specific tools you plan to use (nvim, tmux, etc.)

## Installation

1. Clone the repository if you haven't already:
   ```bash
   git clone https://github.com/yourusername/dev-env.git
   cd dev-env/dotfiles
   ```

2. Stow specific configurations:
   ```bash
   # Individual tools
   stow -v -t ~ nvim      # Neovim config
   stow -v -t ~ wezterm   # Wezterm config
   stow -v -t ~ git      # Git config
   stow -v -t ~ zsh      # Zsh config
   
   # Or stow everything at once
   cd ..
   stow -v -t ~ dotfiles
   ```

## Managing Configurations

### Adding New Configurations
```bash
# Create new configuration directory
mkdir -p new-tool/.config/new-tool
# Add configuration files
# Stow the new configuration
stow -v -t ~ new-tool
```

### Removing Configurations
```bash
# Remove individual config
stow -D -t ~ nvim     # Remove neovim config

# Or remove everything
cd ..
stow -D -t ~ dotfiles
```

### Restowing After Changes
```bash
# Restow individual config
stow -R -t ~ nvim     # Restow neovim config

# Or restow everything
cd ..
stow -R -t ~ dotfiles
```

## Tool-Specific Documentation

Each tool's directory contains its own configuration files and may include a README with tool-specific setup instructions and customizations.
