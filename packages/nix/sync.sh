#!/bin/bash
set -e

# Print the current directory for debugging
echo "Running Nix sync from: $(pwd)"

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
  echo "Would have used nixswitch alias (MY_NIX=$MY_NIX)"
  exit 0
fi

# Check if we can run interactively
if [ -t 1 ] && [ -z "$TURBO_INVOCATION_DIR" ]; then
  # We're running in a terminal and not under Turbo - proceed with full nixup
  echo "Running in interactive terminal, proceeding with nixup"
  
  # Run nixup: update packages, rebuild and switch system configuration
  echo "Updating and rebuilding system with nixup"
  
  # Go to the nix directory first
  cd "$MY_NIX"
  
  # Update flake inputs
  echo "Updating flake inputs..."
  nix flake update
  
  # Rebuild and switch
  echo "Rebuilding and switching..."
  darwin-rebuild switch --flake "$MY_NIX#macos" || {
    echo "Warning: darwin-rebuild failed, this may be expected in certain environments"
    # Exit with success to prevent turbo from failing the entire build
    exit 0
  }
elif [ -n "$TURBO_INVOCATION_DIR" ]; then
  # Display instructions for manual execution
  echo "=============================================="
  echo "🔐 Nix needs sudo access in an interactive shell"
  echo "📋 Please run one of these commands in your terminal:"
  echo ""
  echo "    darwin-rebuild switch --flake \"$MY_NIX#macos\" && nix-collect-garbage --delete-old"
  echo ""
  echo "Using NIX_PATH: $MY_NIX"
  echo ""
  echo "Or simply run one of these aliases:"
  echo ""
  echo "    nixswitch - rebuild and switch"
  echo "    nixup     - update packages and rebuild"
  echo "=============================================="

  # Exit with success to prevent turbo from failing
  exit 0
else
  # We're not in a TTY but also not under Turbo
  echo "Not running in an interactive terminal, skipping Nix operations"
  echo "Please run nixup or nixswitch manually in your shell"
  exit 0
fi

# Clean up old generations
echo "Cleaning up old generations"
nix-collect-garbage --delete-old

echo "Nix sync completed successfully"
