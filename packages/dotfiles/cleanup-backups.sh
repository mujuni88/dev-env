#!/bin/bash
set -e

DOTFILES_DIR="/Users/jbuza/dev-env/packages/dotfiles"
cd "$DOTFILES_DIR"

# Clean up backup directories
echo "Cleaning up backup directories..."
find . -name "*-backup" -type d -exec rm -rf {} \; 2>/dev/null || true
echo "Backup directories removed."

# Clean up backup files
echo "Cleaning up backup files..."
find . -name "*.backup" -type f -exec rm -f {} \; 2>/dev/null || true
echo "Backup files removed."

echo "Cleanup complete!"