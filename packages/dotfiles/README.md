# Dotfiles

My personal dotfiles managed with Dotbot. These configurations work in conjunction with my [Nix configuration](../nix/README.md) to create a complete development environment.

## Structure

```
.
├── aerospace/    # AeroSpace window manager configuration
├── bat/          # Syntax highlighting and paging configuration
├── carapace/     # Shell completion framework configuration
├── codex/        # OpenAI Codex configuration
├── ghostty/      # Terminal emulator configuration
├── git/          # Git configuration and aliases
├── karabiner/    # Keyboard customization for home row mode navigation
├── lazygit/      # Git UI tool configuration
├── mcp/          # Model Context Protocol configuration
├── ni/           # Universal package manager runner (@antfu/ni)
├── nushell/      # Alternative shell configuration
├── nvim/         # Neovim configuration and plugins
├── scripts/      # Custom shell scripts and utilities
├── starship/     # Cross-shell prompt configuration
├── tmux/         # Terminal multiplexer configuration
├── yazi/         # Terminal file manager configuration
├── zed/          # Zed editor configuration
├── zellij/       # Terminal workspace manager configuration
└── zsh/          # Shell configuration and aliases
```

## Prerequisites

- Git
- The specific tools you plan to use (nvim, tmux, etc.)

## Installation

**Recommended:** Use the bootstrap script from the repository root:
```bash
curl -fsSL https://raw.githubusercontent.com/mujuni88/dev-env/main/bootstrap.sh | bash
```

This handles all prerequisites (Nix, Bun, nix-darwin) and sets up the complete environment.

### Manual Installation

<details>
<summary>Click to expand manual steps</summary>

1. Clone the repository if you haven't already:
   ```bash
   git clone https://github.com/mujuni88/dev-env.git
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

</details>

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

## Featured Tools

### Window Management & Terminal

- **aerospace** - Tiling window manager for macOS with i3-like keyboard-driven workflow
- **ghostty** - Fast, feature-rich GPU-accelerated terminal emulator
- **tmux** - Terminal multiplexer for managing multiple terminal sessions
- **zellij** - Modern terminal workspace with layouts and built-in collaboration

### File Management & Navigation

- **yazi** - Blazingly fast terminal file manager with image preview support
- **lazygit** - Terminal UI for git with interactive staging, branching, and commit management

### Shell & Completion

- **zsh** - Primary shell with custom aliases, functions, and environment configuration
- **nushell** - Alternative shell with structured data pipelines
- **carapace** - Multi-shell completion framework supporting 400+ CLI tools
- **starship** - Cross-shell prompt with rich customization and git integration

### Development Tools

- **nvim** - Neovim editor with LSP, treesitter, and extensive plugin configuration
- **zed** - Collaborative code editor with native performance
- **git** - Version control configuration with aliases and commit templates

### Package Management

- **ni** - Universal package manager runner that auto-detects npm/yarn/pnpm/bun
  - Use `ni` instead of `npm install`, `yarn`, `pnpm install`, or `bun install`
  - Automatically detects the right package manager for each project

### AI & Automation

- **codex** - OpenAI Codex integration for AI-assisted development
- **mcp** - Model Context Protocol for connecting AI models with development tools

### Utilities

- **bat** - Enhanced `cat` with syntax highlighting and git integration
- **karabiner** - Advanced keyboard customization for macOS (home row mods, hyper key)
- **scripts** - Collection of custom shell utilities and helper scripts

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
