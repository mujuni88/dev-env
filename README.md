# Development Environment

My personal development environment for macOS, combining the power of Nix for system management with dotfiles for tool configurations.

## What's Inside

- **System Management** (`nix/`): Uses nix-darwin for declarative macOS system configuration
  - Package management
  - System preferences
  - Service management
  
- **Tool Configurations** (`dotfiles/`): Managed with GNU Stow
  - Terminal: Ghostty, Zsh, Starship, Tmux
  - Development: Neovim, Git, and more
  - Utilities: bat, fzf, ripgrep

## Quick Start

1. **Prerequisites**
   - macOS
   - [Nix package manager](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer)
   - Git

2. **Installation**
   ```bash
   # Clone the repository
   git clone <repository_url>
   cd dev-env

   # Set up environment variable
   export MY_DEV=$(pwd)
   ```

3. **Choose Your Setup**

   - For full system configuration:
     → Follow the [Nix Setup Guide](nix/README.md)
   
   - For tool configurations only:
     → Follow the [Dotfiles Setup Guide](dotfiles/README.md)

## Common Tasks

- **Update System**: `nixup` (updates and rebuilds Nix configuration)
- **Apply Changes**: `nixswitch` (rebuilds and switches to new configuration)
- **Edit Config**: `nixedit` (opens Nix configuration in Neovim)

## Documentation

- [Nix Configuration](nix/README.md)
  - System packages and preferences
  - Darwin configuration
  - Flake management

- [Dotfiles](dotfiles/README.md)
  - Tool configurations
  - Installation instructions
  - Component-specific settings

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to use this as inspiration for your own development environment. Issues and pull requests are welcome!
