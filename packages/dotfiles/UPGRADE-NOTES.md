# Dotfiles Setup Upgrade Notes

## Summary of Changes

1. **Replaced GNU Stow with Dotbot**
   - More reliable symlink management
   - YAML-based configuration instead of CLI flags
   - Configure links in `install.conf.yaml`
   - Dotbot installed via Nix/Homebrew, not as a submodule

2. **Simplified Workflow**
   - All dotfile management integrated with monorepo
   - Nix manages all package installations (including dotbot)
   - Dotfiles sync depends on Nix being up-to-date

3. **Updated Commands**
   - `devsetup` - Single command that runs nixswitch first, then completes full setup including dotfiles sync

## Setup Instructions

1. Update your root `turbo.json` file according to TURBO-INSTRUCTIONS.md
2. That's it! Your existing setup just works better now.

## Force Mode

Force mode is now enabled by default in `install.conf.yaml`. This ensures your dotfiles are always in the expected state.

## Nix-First Approach

All tools are now managed through Nix:
- `nixswitch` must be run before any dotfiles operations
- Dotbot is installed via Homebrew which is managed by Nix
- No need for manual upgrades - Nix handles everything