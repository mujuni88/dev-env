# Nix Configuration

This directory contains my Nix-based system configuration for macOS using [nix-darwin](https://github.com/LnL7/nix-darwin?tab=readme-ov-file). It uses the flakes feature for reproducible builds.

## Quick Start

**Recommended:** Use the bootstrap script from the repository root:
```bash
curl -fsSL https://raw.githubusercontent.com/mujuni88/dev-env/main/bootstrap.sh | bash
```

This handles Nix installation, nix-darwin bootstrap, and all dependencies automatically.

## Manual Installation

<details>
<summary>Click to expand manual steps</summary>

1. Install [Nix](https://nixos.org/download/)
```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Build your flake
```bash
# cd inside nix directory
cd dev-env/packages/nix

# Run inside nix directory (requires sudo for system activation)
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake ".#macos"
```

</details>


## Structure

- `flake.nix` - Main configuration file
- `modules/` - Module configurations
- `flake.lock` - Dependency lockfile

## Environment Variables

- `MY_NIX` - Nix configuration directory (`$MY_DEV/nix`)

## Quick Commands

- `nixswitch` - Rebuild and switch system configuration (automatically cleans up old generations)
- `nixup` - Update flake inputs and rebuild system
- `nixedit` - Open nix configuration in neovim

## Usage

1. Edit the configuration:
   ```bash
   nixedit  # Alias for: cd $MY_NIX && nvim .
   ```

2. Build and switch to the new configuration:
   ```bash
   nixswitch  # Alias for: sudo darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old
   ```

3. Update flake inputs and rebuild:
   ```bash
   nixup  # Alias for: cd $MY_NIX && nix flake update && nixswitch
   ```

Note: Every time you run `nixswitch` or `nixup`, it automatically cleans up old system generations while keeping the current one as a backup.

## Adding New Packages

1. Open the configuration:
   ```bash
   nixedit
   ```

2. Add your package to the appropriate section in `flake.nix`

3. Apply the changes:
   ```bash
   nixswitch
   ```

## Troubleshooting

If you encounter issues:

1. Check the error messages in the build output
2. Verify that your changes in `flake.nix` are properly formatted
3. Try running `nixup` to ensure you have the latest package versions
4. Make sure `system.primaryUser` is set correctly in your configuration
5. If needed, you can roll back to the previous generation using `sudo darwin-rebuild switch --rollback` (note: this is not aliased)

### Required Configuration

Starting with nix-darwin's recent updates, you must specify a primary user for user-specific settings:

```nix
system = {
  primaryUser = "yourusername"; # Required for homebrew, user defaults, etc.
  # ...other settings...
};
```

This is required for features like Homebrew integration and system defaults.
