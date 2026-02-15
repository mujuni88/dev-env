#!/bin/bash
# Sync Claude skills to other AI agent skill directories
# This script is idempotent - safe to run multiple times

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CLAUDE_SKILLS="$HOME/.claude/skills"

# Agent skill directories to sync into
TARGETS=(
  "$HOME/.codex/skills"
)

if [ ! -d "$CLAUDE_SKILLS" ]; then
  echo -e "${YELLOW}~/.claude/skills not found, skipping skill sync${NC}"
  exit 0
fi

echo -e "${GREEN}Syncing Claude skills to other agents...${NC}"

for target in "${TARGETS[@]}"; do
  agent=$(basename "$(dirname "$target")")
  mkdir -p "$target"

  for skill in "$CLAUDE_SKILLS"/*/; do
    [ -d "$skill" ] || continue
    name=$(basename "$skill")
    ln -sfn "$skill" "$target/$name"
    echo -e "   ${agent}/skills/${name} ${GREEN}-> ${skill}${NC}"
  done
done

echo -e "${GREEN}Skills synced${NC}"
