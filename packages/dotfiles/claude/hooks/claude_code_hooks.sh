#!/bin/bash
# Claude Code Hook Scripts
#
# These scripts integrate with Claude Code's hook system to automatically send
# Slack notifications for various events. Configure these in your Claude Code settings.

# Configuration - Set CLAUDE_NETFLIX_CHANNEL env var in ~/.claude/settings.json
NETFLIX_CHANNEL="${CLAUDE_NETFLIX_CHANNEL:-}"
if [ -z "$NETFLIX_CHANNEL" ]; then
    echo "Error: CLAUDE_NETFLIX_CHANNEL not set. Add it to ~/.claude/settings.json env section."
    exit 1
fi
NOTIFIER_SCRIPT="$(dirname "$0")/slack_notifier.py"

# Check if notifier script exists
if [ ! -f "$NOTIFIER_SCRIPT" ]; then
    echo "Error: Notifier script not found at $NOTIFIER_SCRIPT"
    exit 1
fi

# Read hook event from stdin JSON
if [ -t 0 ]; then
    hook_event=""
else
    if command -v jq > /dev/null 2>&1; then
        stdin_data=$(cat)
        if [ -n "$stdin_data" ]; then
            hook_event=$(echo "$stdin_data" | jq -r '.hook_event_name // "empty"' 2>/dev/null)
        else
            hook_event=""
        fi
    else
        hook_event=""
    fi
fi

# Send notification with hook event in title
python3 "$NOTIFIER_SCRIPT" \
    --channel "$NETFLIX_CHANNEL" \
    --type "info" \
    --title "Claude Code ${hook_event:-Event}" \
    --message "Triggered by ${hook_event:-unknown event}"
