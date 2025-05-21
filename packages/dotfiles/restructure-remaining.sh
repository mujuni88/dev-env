#!/bin/bash
set -e

DOTFILES_DIR="/Users/jbuza/dev-env/packages/dotfiles"
cd "$DOTFILES_DIR"

# Special case for tmux
mkdir -p tmux-new
cp -rv tmux/.config/tmux/.tmux.conf tmux-new/
mv -v tmux tmux-backup
mv -v tmux-new tmux
echo "Successfully restructured tmux"

# Handle remaining directories
for dir in "yazi" "zellij" "zsh"; do
  echo "Processing $dir..."
  
  # Create temporary directory
  temp_dir="${dir}-new"
  mkdir -p "$temp_dir"
  
  # Find the source directory
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