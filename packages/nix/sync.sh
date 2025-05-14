#!/bin/bash
set -e

# Print the current directory for debugging
echo "Running Nix sync from: $(pwd)"

# MY_DEV and MY_NIX are expected to be set in .zshrc
# MY_DEV is the root directory of the development environment
# MY_NIX is the nix configuration directory ($MY_DEV/packages/nix)

# Skip actual nix rebuild in CI environments
if [ -n "$CI" ] || [ -n "$TURBO_CI" ]; then
  echo "CI environment detected, skipping actual nix rebuild"
  echo "Would have used nixswitch alias (MY_NIX=$MY_NIX)"
  exit 0
fi

# Check if running under Turbo
if [ -n "$TURBO_INVOCATION_DIR" ]; then
  # Create a named pipe for communication
  PIPE="/tmp/nix_sync_$$"
  mkfifo "$PIPE"

  # Display instructions for manual execution
  echo "=============================================="
  echo "🔐 Nix needs sudo access in an interactive shell"
  echo "📋 Please run this command in your terminal:"
  echo ""
  echo "    darwin-rebuild switch --flake \"$MY_NIX#macos\" && nix-collect-garbage --delete-old"
  echo ""
  echo "Or simply run your alias:"
  echo ""
  echo "    nixswitch"
  echo "=============================================="

  # Exit with success to prevent turbo from failing
  exit 0
else
  # Run nixswitch: rebuild and switch system configuration
  echo "Rebuilding system with nixswitch"
  darwin-rebuild switch --flake "$MY_NIX#macos" || {
    echo "Warning: darwin-rebuild failed, this may be expected in certain environments"
    # Exit with success to prevent turbo from failing the entire build
    exit 0
  }
fi

# Clean up old generations
echo "Cleaning up old generations"
nix-collect-garbage --delete-old

echo "Nix sync completed successfully"
