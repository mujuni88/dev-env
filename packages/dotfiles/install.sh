#!/bin/bash
set -e

CONFIG="install.conf.yaml"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"

# Make sure .config directory exists
mkdir -p "${HOME}/.config"

# Find dotbot command - we use Homebrew to install dotbot
DOTBOT_CMD=$(which dotbot)
if [ -z "$DOTBOT_CMD" ]; then
  echo "Error: dotbot command not found. Please make sure it's installed via Homebrew."
  echo "Run: brew install dotbot"
  exit 1
fi

# Run dotbot
"$DOTBOT_CMD" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
