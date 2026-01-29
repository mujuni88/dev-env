#!/bin/bash
set -e

# Print the current directory for debugging
echo "Running Nix build from: $(pwd)"

# MY_DEV and MY_NIX are expected to be set in .zshrc
# MY_DEV is the root directory of the development environment
# MY_NIX is the nix configuration directory ($MY_DEV/packages/nix)

# Set MY_NIX if not already set to avoid empty variable errors
if [ -z "$MY_NIX" ]; then
  # Determine script location
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  MY_NIX="$SCRIPT_DIR"
  echo "MY_NIX not set, using script directory: $MY_NIX"
fi

# Skip actual nix rebuild in CI environments
if [ -n "$CI" ] || [ -n "$TURBO_CI" ]; then
  echo "CI environment detected, skipping actual nix rebuild"
  echo "Would have used ns alias (MY_NIX=$MY_NIX)"
  exit 0
fi

# Check if we're running in turbo
if [ -n "$TURBO_INVOCATION_DIR" ]; then
  # Display instructions for manual execution
  echo "=============================================="
  echo "🔐 Nix needs sudo access in an interactive shell"
  echo "📋 Please run one of these commands in your terminal:"
  echo ""
  echo "    sudo darwin-rebuild switch --flake \"$MY_NIX#macos\" && nix-collect-garbage --delete-old"
  echo ""
  echo "Or simply run one of these aliases:"
  echo ""
  echo "    ns - rebuild and switch"
  echo "    nu - update packages and rebuild"
  echo "=============================================="
  exit 0
fi

# Run the nix update and switch
echo "Updating and rebuilding system with nix..."
cd "$MY_NIX"

# Update flake inputs
echo "Updating flake inputs..."
nix flake update

# Rebuild and switch
echo "Rebuilding and switching..."
sudo darwin-rebuild switch --flake "$MY_NIX#macos"

# Clean up old generations
echo "Cleaning up old generations"
nix-collect-garbage --delete-old

echo "Nix build completed successfully"
