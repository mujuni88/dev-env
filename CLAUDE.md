# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build and Development
- Install dependencies: `bun install`
- Build all packages: `bun run build`
- Run setup script: `bun run setup` (installs deps and runs sync)
- Sync packages: `bun run sync`
- For nix sync, use: `export TURBO_CI=1 && bun run setup`

### Nix Commands
- Rebuild configuration: `nixswitch` (alias for `darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old`)
- Update and rebuild: `nixup` (alias for `cd $MY_NIX && nix flake update && nixswitch`)
- Edit configuration: `nixedit` (alias for `cd $MY_NIX && nvim .`)

### Environment Notes
- `ls` is aliased to `eza` with custom formatting options
- Many common commands are aliased (e.g., `cat` to `bat`, `vim` to `nvim`)

## Code Guidelines

### Project Structure
- Monorepo using Turborepo with packages in `packages/` and `apps/`
- Key packages: nix, dotfiles, zmk, dygma, node-tools

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