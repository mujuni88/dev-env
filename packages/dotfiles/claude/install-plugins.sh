#!/bin/bash
# Install Claude Code plugins
# This script is idempotent - safe to run multiple times

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Plugins to install (from claude-plugins-official marketplace)
PLUGINS=(
  "atlassian"
  "code-review"
  "commit-commands"
  "context7"
  "explanatory-output-style"
  "feature-dev"
  "figma"
  "frontend-design"
  "github"
  "hookify"
  "plugin-dev"
  "pr-review-toolkit"
  "slack"
)

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
  echo -e "${YELLOW}⚠️  Claude CLI not found, skipping plugin installation${NC}"
  echo "   Install Claude Code first: https://claude.ai/code"
  exit 0
fi

echo -e "${GREEN}🔌 Installing Claude Code plugins...${NC}"

for plugin in "${PLUGINS[@]}"; do
  echo -n "   Installing $plugin... "
  if claude plugins install "$plugin" &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
  else
    # Plugin might already be installed or have an error
    echo -e "${YELLOW}(already installed or skipped)${NC}"
  fi
done

echo -e "${GREEN}✅ Claude Code plugins ready${NC}"
