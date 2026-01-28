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

- **Node Tools** (`packages/node-tools`): Globally installed Node.js utilities

## Quick Start

### One-Liner Setup (Fresh Mac)

```bash
curl -fsSL https://raw.githubusercontent.com/mujuni88/dev-env/main/bootstrap.sh | bash
```

This will:
1. Install Xcode Command Line Tools
2. Install Nix package manager
3. Install Bun runtime
4. Clone the repository to `~/dev-env`
5. Bootstrap nix-darwin (installs Homebrew + system packages)
6. Optionally install Claude Code for interactive setup completion

After bootstrap completes, start a new terminal and run:
```bash
cd ~/dev-env && claude
# Then tell Claude: "Complete my dev-env setup"
```

### Manual Installation

<details>
<summary>Click to expand manual steps</summary>

1. **Prerequisites**
   - macOS
   - [Nix package manager](packages/nix/README.md)
   - Git
   - [Bun](https://bun.sh) (for both runtime and package management)

2. **Installation**
   ```bash
   # Clone the repository
   git clone https://github.com/mujuni88/dev-env.git
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

</details>

### Bootstrap Options

```bash
./bootstrap.sh --no-ai      # Skip AI assistant installation
./bootstrap.sh --claude     # Install Claude Code (non-interactive)
./bootstrap.sh --opencode   # Install OpenCode (non-interactive)
./bootstrap.sh --ai-only    # Skip prerequisites, just install AI tools
```

### Verify Installation

After bootstrap, verify everything installed correctly:

```bash
./verify-bootstrap.sh           # Run all checks
./verify-bootstrap.sh --verbose # Show detailed output
./verify-bootstrap.sh --fix     # Show fix commands for failures
```

## Common Tasks

### Development Environment Setup

- **Complete setup**: `bun run setup` - Install system dependencies, global tools, and configure dotfiles
- **System dependencies**: `bun run system-install` - Install apps and tools via Nix
- **Global tools**: `bun run global-install` - Install global npm packages and CLI tools
- **Dotfiles only**: `bun run dotfiles-install` - Configure dotfiles and shell settings
- **Update configs**: `bun run update` - Sync existing configurations

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

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to use this as inspiration for your own development environment. Issues and pull requests are welcome!
