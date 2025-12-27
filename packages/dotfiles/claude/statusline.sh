#!/bin/bash

# Claude Code Custom Status Line
# v4.1.0 - Powerline + Context Bricks visualization

# Read JSON from stdin
input=$(cat)

# Output powerline (first line)
echo "$input" | bunx @owloops/claude-powerline@1.13.2 --style=minimal --theme=dark 2>/dev/null

# Session metrics
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
duration_hours=$((duration_ms / 3600000))
duration_min=$(((duration_ms % 3600000) / 60000))
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Context bricks visualization
total_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
current_usage=$(echo "$input" | jq -r '.context_window.current_usage // null')

if [[ "$current_usage" != "null" ]]; then
    input_tokens=$(echo "$current_usage" | jq -r '.input_tokens // 0')
    cache_creation=$(echo "$current_usage" | jq -r '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$current_usage" | jq -r '.cache_read_input_tokens // 0')
    used_tokens=$((input_tokens + cache_creation + cache_read))
else
    used_tokens=0
fi

free_tokens=$((total_tokens - used_tokens))
usage_pct=$(( total_tokens > 0 ? (used_tokens * 100) / total_tokens : 0 ))
used_k=$(( used_tokens / 1000 ))
total_k=$(( total_tokens / 1000 ))
free_k=$(( free_tokens / 1000 ))

# Generate brick visualization (20 bricks)
total_bricks=20
used_bricks=$(( total_tokens > 0 ? (used_tokens * total_bricks) / total_tokens : 0 ))
free_bricks=$((total_bricks - used_bricks))

brick_line="["
for ((i=0; i<used_bricks; i++)); do brick_line+="\033[0;36m■\033[0m"; done
for ((i=0; i<free_bricks; i++)); do brick_line+="\033[2;37m□\033[0m"; done
brick_line+="] \033[1m${usage_pct}%\033[0m (${used_k}k/${total_k}k) | \033[1;32m${free_k}k free\033[0m | ${duration_hours}h ${duration_min}m | \033[0;32m+${lines_added}\033[0m/\033[0;31m-${lines_removed}\033[0m"

# Output bricks (with top margin)
echo ""
echo -e "${brick_line}"
