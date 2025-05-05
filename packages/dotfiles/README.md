# Dotfiles

My personal dotfiles managed with GNU Stow. These configurations work in conjunction with my [Nix configuration](../nix/README.md) to create a complete development environment.

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

- GNU Stow (for managing symlinks)
- Git
- The specific tools you plan to use (nvim, tmux, etc.)

## Installation

1. Clone the repository if you haven't already:
   ```bash
   git clone <repository_url>
   cd dev-env/dotfiles
   ```

2. Stow configurations:
   ```bash
   # Stow individual packages
   stow nvim      # Neovim config -> ~/.config/nvim
   stow ghostty   # Ghostty config -> ~/.config/ghostty
   stow starship  # Starship config -> ~/.config/starship
   stow git       # Git config -> ~/.gitconfig
   stow zsh       # Zsh config -> ~/.zshrc
   
   # Or stow everything at once (recommended)
   stow */        # Stows all directories, using settings from .stowrc
   ```

Note: The `.stowrc` file is configured to:
- Target your home directory (`~`)
- Ignore unnecessary files (`.DS_Store`, `.stowrc`, `README.md`)
- Preserve the `.config` directory structure where needed

## Managing Configurations

### Adding New Configurations
```bash
# Create new configuration directory
mkdir -p new-tool/.config/new-tool
# Add configuration files
# Stow the new configuration
stow new-tool
```

### Removing Configurations
```bash
# Remove individual config
stow -D nvim     # Remove neovim config

# Or remove everything
stow -D */
```

### Restowing After Changes
```bash
# Restow individual config
stow -R nvim     # Restow neovim config

# Or restow everything
stow -R */       # Restow all configurations

# You can also use the convenient alias:
dots        # Restow all configurations
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
