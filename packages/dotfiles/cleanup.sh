#!/bin/bash

# Script to clean up dotfiles directory structure
# Removes .DS_Store files and unnecessary nested .config directories

# Set the base directory
BASE_DIR="/Users/jbuza/dev-env/packages/dotfiles"
echo "Cleaning up dotfiles in $BASE_DIR"

# Remove all .DS_Store files
echo "Removing .DS_Store files..."
find "$BASE_DIR" -name ".DS_Store" -type f -delete

# Clean up duplicate .config directories for directories that should be linked directly
for dir in nvim ghostty zellij zsh nushell; do
  if [ -d "$BASE_DIR/$dir/.config/$dir" ]; then
    echo "Found duplicate .config directory in $dir"
    
    # If there are actual files (not just empty dirs) in the nested location, move them up
    if [ -n "$(find "$BASE_DIR/$dir/.config/$dir" -type f 2>/dev/null)" ]; then
      echo "Moving files from $BASE_DIR/$dir/.config/$dir to $BASE_DIR/$dir"
      cp -R "$BASE_DIR/$dir/.config/$dir/"* "$BASE_DIR/$dir/"
    fi
    
    # Remove the nested .config directory
    echo "Removing $BASE_DIR/$dir/.config"
    rm -rf "$BASE_DIR/$dir/.config"
  fi
done

# Find any empty directories and remove them
echo "Removing empty directories..."
find "$BASE_DIR" -type d -empty -delete

echo "Cleanup complete!"