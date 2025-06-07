# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Note**: If project instructions are not found in this file, make sure to look inside `.cursor` or `.windsurf` folders for additional instructions.
>
> **Important**: Do not ignore dotfiles (files/folders starting with `.`) inside the `packages/dotfiles/` directory, as they are configuration files that need to be managed.

## Commands

### Build and Development

- Install dependencies: `bun install`
- Complete setup: `bun run setup` - Install system dependencies, global tools, and configure dotfiles
- System dependencies: `bun run system-install` - Install apps and tools via Nix
- Global tools: `bun run global-install` - Install global npm packages and CLI tools
- Dotfiles setup: `bun run dotfiles-install` - Configure dotfiles and shell settings
- Update configs: `bun run update` - Sync existing configurations

### TypeScript Native Preview (tsgo)

- Run TypeScript compiler with native preview: `npx tsgo --project ./path/to/tsconfig.json`
- Install tsgo globally: included in `packages/node-tools`

### Nix Commands

- Rebuild configuration: `nixswitch` (alias for `sudo darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old`)
- Update and rebuild: `nixup` (alias for `cd $MY_NIX && nix flake update && nixswitch`)
- Edit configuration: `nixedit` (alias for `cd $MY_NIX && nvim .`)
- Roll back to previous configuration: `darwin-rebuild switch --rollback` (no alias)

### Dotfiles Management

- Install all dotfiles: `bun run dotfiles-install` (from project root)
- Update dotfiles after changes: `bun run update` (from project root)
- Direct install: `cd packages/dotfiles && ./install` (for debugging)

### Environment Variables

- `MY_DEV`: Root of the dev-env repository
- `MY_NIX`: Nix configuration directory (`$MY_DEV/packages/nix`)

### Environment Notes

- Bun is used as both the runtime and package manager (`>=1.0.0`)

## Project Architecture

### Monorepo Structure

- Turborepo manages the monorepo with packages in `packages/` and `apps/`
- Key packages:
  - `packages/nix`: macOS system configuration using nix-darwin
  - `packages/dotfiles`: Tool configurations managed with Dotbot
  - `packages/zmk`: ZMK firmware configuration for Glove80 keyboard
  - `packages/dygma`: Dygma keyboard configuration
  - `packages/node-tools`: Global Node.js package management (installs dependencies globally via npm)

### Build System

- Turborepo orchestrates building, syncing, and other operations
- Configuration in `turbo.json` defines the pipeline and cache settings
- Tasks can be run across all packages or individual packages

### Nix Configuration

- Uses nix-darwin for macOS system management
- Flake-based for reproducible builds
- Main configuration in `packages/nix/flake.nix`
- Modular organization in `packages/nix/modules/`

### Dotfiles System

- Uses Dotbot for symlink management
- Each tool has its own directory with configurations
- `install.conf.yaml` controls symlink creation
- Common tools: nvim, git, ghostty, zsh, tmux, starship

## Code Guidelines

### Style Conventions

- Follow existing code style in each package
- Use absolute imports where possible
- Maintain consistent formatting within files

### Error Handling

- Use appropriate error handling for the context (promises, try/catch)
- Log errors with meaningful messages

### Documentation

- Document functions and modules with clear purpose
- Update README files when making substantial changes

### Keyboard Configuration

- ZMK firmware management for Glove80 keyboard
- Dygma keyboard management for Defy keyboard
- Changes require rebuilding firmware files
