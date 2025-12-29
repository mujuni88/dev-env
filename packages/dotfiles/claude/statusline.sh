#!/usr/bin/env bash

# Claude Code Custom Status Line
# v7.0.0 - Simple line selection
#
# Configure which lines to show by editing LINES below.
# Each array element = one line. Space-separate to combine.
#
# Available components:
#   powerline  - External powerline via @owloops/claude-powerline
#   gitline    - [Model] repo:branch [commit] msg | github | status | +/-
#   bricksline - [■■□□] 45% (90k/200k) | 110k free | 2h 15m | +/- | $1.23
#
# Examples:
#   LINES=("bricksline" "gitline")           # bricks on line 1, git on line 2
#   LINES=("gitline" "bricksline")           # git on line 1, bricks on line 2
#   LINES=("powerline bricksline")           # powerline + bricks on same line
#   LINES=("powerline bricksline" "gitline") # combined line 1, git on line 2
#   LINES=("powerline")                      # just powerline
#   LINES=("gitline")                        # just git info
#   LINES=("bricksline")                     # just context bricks

LINES=("powerline" "bricksline")
BRICK_COUNT=20

# ============================================================================
# READ INPUT & PARSE DATA
# ============================================================================

input=$(cat)
declare -A CACHE

get_value() {
    local key="$1"
    local jq_path="$2"
    local default="$3"

    if [[ -z "${CACHE[$key]+isset}" ]]; then
        CACHE[$key]=$(echo "$input" | jq -r "$jq_path // \"$default\"")
    fi
    echo "${CACHE[$key]}"
}

compute_context() {
    if [[ -z "${CACHE[context_computed]+isset}" ]]; then
        CACHE[total_tokens]=$(get_value total_tokens '.context_window.context_window_size' '200000')

        local current_usage=$(echo "$input" | jq -r '.context_window.current_usage // null')
        if [[ "$current_usage" != "null" ]]; then
            local input_tokens=$(echo "$current_usage" | jq -r '.input_tokens // 0')
            local cache_creation=$(echo "$current_usage" | jq -r '.cache_creation_input_tokens // 0')
            local cache_read=$(echo "$current_usage" | jq -r '.cache_read_input_tokens // 0')
            CACHE[used_tokens]=$((input_tokens + cache_creation + cache_read))
        else
            CACHE[used_tokens]=0
        fi

        CACHE[free_tokens]=$((CACHE[total_tokens] - CACHE[used_tokens]))
        CACHE[usage_pct]=$(( CACHE[total_tokens] > 0 ? (CACHE[used_tokens] * 100) / CACHE[total_tokens] : 0 ))
        CACHE[used_k]=$(( CACHE[used_tokens] / 1000 ))
        CACHE[total_k]=$(( CACHE[total_tokens] / 1000 ))
        CACHE[free_k]=$(( CACHE[free_tokens] / 1000 ))
        CACHE[context_computed]=1
    fi
}

compute_git() {
    if [[ -z "${CACHE[git_computed]+isset}" ]]; then
        local current_dir=$(get_value current_dir '.workspace.current_dir' "$PWD")
        cd "$current_dir" 2>/dev/null || cd "$HOME"

        if git rev-parse --git-dir > /dev/null 2>&1; then
            CACHE[repo_name]=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "")
            CACHE[branch]=$(git branch --show-current 2>/dev/null || echo "detached")
            CACHE[commit_short]=$(git rev-parse --short HEAD 2>/dev/null || echo "")
            CACHE[commit_msg]=$(git log -1 --pretty=%s 2>/dev/null | cut -c1-40 || echo "")

            local github_url=$(git config --get remote.origin.url 2>/dev/null)
            if [[ $github_url =~ github.com[:/](.+/.+)(\.git)?$ ]]; then
                CACHE[github_repo]="${BASH_REMATCH[1]%.git}"
            else
                CACHE[github_repo]=""
            fi

            local status=""
            [[ -n $(git status --porcelain 2>/dev/null) ]] && status="*"

            local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
            if [[ -n "$upstream" ]]; then
                local ahead=$(git rev-list --count "$upstream"..HEAD 2>/dev/null || echo "0")
                local behind=$(git rev-list --count HEAD.."$upstream" 2>/dev/null || echo "0")
                [[ "$ahead" -gt 0 ]] && status="${status}↑${ahead}"
                [[ "$behind" -gt 0 ]] && status="${status}↓${behind}"
            fi
            CACHE[git_status]="$status"
            CACHE[in_git_repo]=1
        else
            CACHE[in_git_repo]=0
        fi
        CACHE[git_computed]=1
    fi
}

# ============================================================================
# LINE RENDERERS
# ============================================================================

render_powerline() {
    echo "$input" | bunx @owloops/claude-powerline@1.13.2 --style=minimal --theme=dark 2>/dev/null | tr -d '\n'
}

render_gitline() {
    compute_git
    local out=""

    local model=$(get_value model '.model.display_name' 'Claude' | sed 's/Claude //')
    out+="\033[1;36m[$model]\033[0m "

    if [[ "${CACHE[in_git_repo]}" == "1" ]]; then
        out+="\033[1;32m${CACHE[repo_name]}\033[0m"
        [[ -n "${CACHE[branch]}" ]] && out+=":\033[1;34m${CACHE[branch]}\033[0m"

        if [[ -n "${CACHE[commit_short]}" ]]; then
            out+=" [\033[1;33m${CACHE[commit_short]}\033[0m]"
            [[ -n "${CACHE[commit_msg]}" ]] && out+=" ${CACHE[commit_msg]}"
        fi

        [[ -n "${CACHE[github_repo]}" ]] && out+=" | \033[0;35m${CACHE[github_repo]}\033[0m"
        [[ -n "${CACHE[git_status]}" ]] && out+=" \033[1;31m${CACHE[git_status]}\033[0m"
    fi

    local added=$(get_value lines_added '.cost.total_lines_added' '0')
    local removed=$(get_value lines_removed '.cost.total_lines_removed' '0')
    if [[ "$added" -gt 0 || "$removed" -gt 0 ]]; then
        out+=" | \033[0;32m+${added}\033[0m/\033[0;31m-${removed}\033[0m"
    fi

    echo -en "$out"
}

render_bricksline() {
    compute_context

    local used_bricks=$(( CACHE[total_tokens] > 0 ? (CACHE[used_tokens] * BRICK_COUNT) / CACHE[total_tokens] : 0 ))
    local free_bricks=$((BRICK_COUNT - used_bricks))

    local out="["
    for ((i=0; i<used_bricks; i++)); do out+="\033[0;36m■\033[0m"; done
    for ((i=0; i<free_bricks; i++)); do out+="\033[2;37m□\033[0m"; done
    out+="] \033[1m${CACHE[usage_pct]}%\033[0m (${CACHE[used_k]}k/${CACHE[total_k]}k)"
    out+=" | \033[1;32m${CACHE[free_k]}k free\033[0m"

    local duration_ms=$(get_value duration_ms '.cost.total_duration_ms' '0')
    local hours=$((duration_ms / 3600000))
    local mins=$(((duration_ms % 3600000) / 60000))
    out+=" | ${hours}h ${mins}m"

    local added=$(get_value lines_added '.cost.total_lines_added' '0')
    local removed=$(get_value lines_removed '.cost.total_lines_removed' '0')
    out+=" | \033[0;32m+${added}\033[0m/\033[0;31m-${removed}\033[0m"

    local cost=$(get_value cost '.cost.total_cost_usd' '0')
    local show_cost=0
    if command -v bc &> /dev/null; then
        (( $(echo "$cost > 0" | bc -l 2>/dev/null || echo "0") )) && show_cost=1
    else
        [[ "$cost" != "0" && "$cost" != "0.0" && "$cost" != "0.00" && -n "$cost" ]] && show_cost=1
    fi
    if [[ "$show_cost" == "1" ]]; then
        local formatted=$(printf "%.2f" "$cost" 2>/dev/null || echo "$cost")
        out+=" | \033[0;33m\$${formatted}\033[0m"
    fi

    echo -en "$out"
}

# ============================================================================
# MAIN
# ============================================================================

render_component() {
    case "$1" in
        powerline)  render_powerline ;;
        gitline)    render_gitline ;;
        bricksline) render_bricksline ;;
    esac
}

for line in "${LINES[@]}"; do
    first=1
    for component in $line; do
        [[ $first -eq 0 ]] && echo -n " "
        render_component "$component"
        first=0
    done
    echo
done
