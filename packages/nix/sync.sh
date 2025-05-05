#!/bin/bash
set -e

# Print the current directory for debugging
echo "Running Nix sync from: $(pwd)"

# MY_DEV and MY_NIX are expected to be set in .zshrc
# MY_DEV is the root directory of the development environment
# MY_NIX is the nix configuration directory ($MY_DEV/packages/nix)

# Skip actual nix rebuild in CI or non-interactive environments
if [ -n "$CI" ] || [ -n "$TURBO_CI" ]; then
  echo "CI environment detected, skipping actual nix rebuild"
  echo "Would have used nixswitch alias (MY_NIX=$MY_NIX)"
  exit 0
fi

# Run nixswitch: rebuild and switch system configuration
echo "Rebuilding system with nixswitch"
darwin-rebuild switch --flake "$MY_NIX#macos" || {
  echo "Warning: darwin-rebuild failed, this may be expected in certain environments"
  # Exit with success to prevent turbo from failing the entire build
  exit 0
}

# Clean up old generations
echo "Cleaning up old generations"
nix-collect-garbage --delete-old

echo "Nix sync completed successfully"
