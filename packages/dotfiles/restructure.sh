#!/bin/bash
set -e

DOTFILES_DIR="/Users/jbuza/dev-env/packages/dotfiles"
cd "$DOTFILES_DIR"

# List of directories to restructure
DIRS=(
  "aerospace"
  "bat"
  "ghostty"
  "karabiner"
  "lazygit"
  "nushell"
  "nvim"
  "tmux"
  "yazi"
  "zellij"
  "zsh"
)

# Special case for starship, which is a file not a directory
mv -v starship/.config/starship.toml starship/starship.toml

# For each directory
for dir in "${DIRS[@]}"; do
  echo "Processing $dir..."
  
  # Create temporary directory
  temp_dir="${dir}-new"
  mkdir -p "$temp_dir"
  
  # Find the source directory (most are .config/dirname, but check if it exists)
  if [ -d "$dir/.config/$dir" ]; then
    # Copy all files from .config/dirname to the new directory
    cp -rv "$dir/.config/$dir/"* "$temp_dir/"
  else
    echo "Warning: $dir/.config/$dir does not exist, skipping"
    rm -rf "$temp_dir"
    continue
  fi
  
  # Backup original directory
  mv -v "$dir" "${dir}-backup"
  
  # Rename new directory to original name
  mv -v "$temp_dir" "$dir"
  
  echo "Successfully restructured $dir"
  echo
done

# Move the new install.conf.yaml into place
if [ -f "install.conf.yaml.new" ]; then
  mv -v install.conf.yaml install.conf.yaml.backup
  mv -v install.conf.yaml.new install.conf.yaml
  echo "Updated install.conf.yaml"
fi

echo "Restructuring complete. Original directories are backed up with -backup suffix."
echo "Please test the new structure with ./install before removing backups."