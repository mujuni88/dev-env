# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) when working in any repository.

> **Important**: Do not ignore dotfiles (files/folders starting with `.`) inside the `packages/dotfiles/` directory, as they are configuration files that need to be managed.

## Global Guidelines

### Project Instructions
- If project-specific instructions are not found, look inside `.cursor` or `.windsurf` folders for additional instructions
- Check for repository-specific CLAUDE.md files in project roots

### Code Style
- Follow existing code style in each project
- Use absolute imports where possible
- Maintain consistent formatting within files

### Git Commits
- Use conventional commit format: `type(scope): message`
- Common types: feat, fix, docs, style, refactor, test, chore
- Keep messages concise and descriptive
- Example: `feat(nvim): add markdown preview keybinding`

### Error Handling
- Use appropriate error handling for the context (promises, try/catch)
- Log errors with meaningful messages

### Documentation
- Document functions and modules with clear purpose
- Update README files when making substantial changes

### Development Environment
- `dev-env`: The main development environment repository at `~/dev-env`
- `MY_DEV`: Environment variable pointing to dev-env repository (`$HOME/dev-env`)
- `MY_NIX`: Environment variable pointing to Nix configuration (`$MY_DEV/packages/nix`)
- `devsetup`: Alias for `cd $MY_DEV && bun run setup` (installs deps and runs sync)

## Default Commands

### Common Development
- Build: `bun run build` (uses Turborepo)
- Install dependencies: `bun install`
- Setup: `bun run setup` (installs deps and runs sync)
- Sync packages: `bun run sync`

### Environment Management
- Stow dotfiles: `stow .` (in dotfiles directory)
- Restow dotfiles: `stow -R .` or `dots` alias