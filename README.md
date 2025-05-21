# Development Environment

My personal development environment for macOS, combining the power of Nix for system management with dotfiles for tool configurations.

## What's Inside

## Monorepo Structure

This repository is organized as a monorepo using Turborepo for efficient build orchestration:

### Packages

- **System Management** (`packages/nix`): Uses nix-darwin for declarative macOS system configuration
  - Package management
  - System preferences
  - Service management
  
- **Tool Configurations** (`packages/dotfiles`): Managed with Dotbot
  - Terminal: Ghostty, Zsh, Starship, Tmux
  - Development: Neovim, Git, and more
  - Utilities: bat, fzf, ripgrep

- **Keyboard Firmware** (`packages/zmk`): ZMK firmware configuration

- **Dygma Configuration** (`packages/dygma`): Dygma keyboard configuration

- **Node Tools** (`packages/node-tools`): Globally installed Node.js utilities

## Quick Start

1. **Prerequisites**
   - macOS
   - [Nix package manager](packages/nix/README.md)
   - Git
   - [Bun](https://bun.sh) (for both runtime and package management)

2. **Installation**
   ```bash
   # Clone the repository
   git clone <repository_url>
   cd dev-env

   # Set up environment variable
   export MY_DEV=$(pwd)
   
   # Install dependencies
   bun install
   ```

3. **Choose Your Setup**

   - For full system configuration:
     → Follow the [Nix Setup Guide](packages/nix/README.md)
   
   - For tool configurations only:
     → Follow the [Dotfiles Setup Guide](packages/dotfiles/README.md)

## Common Tasks

### Monorepo Commands

- **Build all packages**: `bun run build`
- **Development mode**: `bun run dev`
- **Lint packages**: `bun run lint`
- **Clean all packages**: `bun run clean`
- **Full setup**: `bun run setup` (installs deps and runs sync)
- **Sync all packages**: `bun run sync`

### Nix Commands

- **Update System**: `nixup` (updates and rebuilds Nix configuration)
- **Apply Changes**: `nixswitch` (rebuilds and switches to new configuration)
- **Edit Config**: `nixedit` (opens Nix configuration in Neovim)
- **Complete Setup**: `devsetup` (runs nixswitch and then full setup)

## Documentation

- [Nix Configuration](packages/nix/README.md)
  - System packages and preferences
  - Darwin configuration
  - Flake management

- [Dotfiles](packages/dotfiles/README.md)
  - Tool configurations
  - Installation instructions
  - Component-specific settings

- [ZMK Firmware](packages/zmk/README.md)
  - Keyboard firmware configuration

- [Dygma Configuration](packages/dygma/README.md)
  - Dygma keyboard settings

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to use this as inspiration for your own development environment. Issues and pull requests are welcome!
