#!/bin/bash
# Back up non-symlink Claude paths before dotbot linking
# This script is idempotent - safe to run multiple times
#
# Dotbot's link step will fail if a real file/directory exists where it
# wants to create a symlink. This preflight moves those out of the way
# with a timestamped suffix so nothing is lost.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
MANAGED_PATHS=(statusline.sh claude-powerline.json hooks skills data)
TS=$(date +%Y%m%d-%H%M%S)

mkdir -p "$CLAUDE_DIR"

for p in "${MANAGED_PATHS[@]}"; do
  target="$CLAUDE_DIR/$p"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.pre-dotfiles-$TS"
    echo -e "   ${YELLOW}Backed up${NC} $p ${YELLOW}-> ${p}.pre-dotfiles-${TS}${NC}"
  fi
done
