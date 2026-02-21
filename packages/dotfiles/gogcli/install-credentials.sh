#!/bin/bash
# Restore gogcli OAuth client credentials from Dashlane.
# This script is idempotent and safe to run multiple times.

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

TEMPLATE_FILE="gogcli/credentials.template"
TARGET_DIR="$HOME/.config/gogcli"
TARGET_FILE="$TARGET_DIR/credentials.json"

if ! command -v dcli >/dev/null 2>&1; then
  echo -e "${YELLOW}⚠️  Dashlane CLI (dcli) not found, skipping gogcli credentials restore${NC}"
  exit 0
fi

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo -e "${RED}❌ Missing template: $TEMPLATE_FILE${NC}"
  exit 1
fi

mkdir -p "$TARGET_DIR"

echo -e "${GREEN}🔐 Restoring gogcli OAuth credentials from Dashlane...${NC}"
if ! dcli inject -i "$TEMPLATE_FILE" -o "$TARGET_FILE"; then
  echo -e "${RED}❌ Failed to inject secret from Dashlane.${NC}"
  echo -e "${YELLOW}   Verify the Dashlane item name in $TEMPLATE_FILE (currently gogcli-oauth).${NC}"
  exit 1
fi

chmod 600 "$TARGET_FILE"

# Validate that injected content is valid JSON.
if ! python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$TARGET_FILE" >/dev/null 2>&1; then
  echo -e "${RED}❌ Injected credentials are not valid JSON: $TARGET_FILE${NC}"
  exit 1
fi

if command -v gog >/dev/null 2>&1; then
  gog auth credentials "$TARGET_FILE" >/dev/null
  echo -e "${GREEN}✅ gogcli OAuth credentials restored and registered${NC}"
else
  echo -e "${GREEN}✅ gogcli OAuth credentials restored${NC}"
  echo -e "${YELLOW}   gog not found in PATH; run this after install:${NC} gog auth credentials \"$TARGET_FILE\""
fi
