#!/bin/bash
echo "🔄 Starting dotfiles sync from $(pwd) to $HOME..."

stow -R -v --adopt */

echo "✨ Dotfiles sync completed!"
