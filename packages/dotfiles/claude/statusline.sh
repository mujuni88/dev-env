#!/usr/bin/env bash

# Claude Code Custom Status Line
# v6.2.0 - Composable with pre-built line components
#
# Configure layout via CLAUDE_STATUS_LAYOUT environment variable.
# Use component names separated by spaces. Use "\n" for line breaks.
#
# Pre-composed lines:
#   gitline        - Full git info: [Model] repo:branch [commit] msg | github | status | +/-
#   bricksline     - Full context bar: [■■□□] 45% (90k/200k) | 110k free | 2h 15m | $1.23
#   powerline      - Powerline prompt (via @owloops/claude-powerline)
#
# Individual components (for custom layouts):
#   model, git, github, gitstatus, lines, bricks, bricksfree, duration, cost, sep
#
# Layout examples:
#   "powerline bricksline"          - Powerline + bricks on same line
#   "gitline \n bricksline"         - Classic two-line layout
#   "powerline \n bricksline"       - Powerline on top, bricks below
#   "powerline sep bricks"          - Powerline with just the brick visualization
#
# Set via:
#   export CLAUDE_STATUS_LAYOUT="powerline bricksline"

# ============================================================================
# CONFIGURATION
# ============================================================================

DEFAULT_LAYOUT="powerline bricksline"
LAYOUT="${CLAUDE_STATUS_LAYOUT:-$DEFAULT_LAYOUT}"
BRICK_COUNT="${CLAUDE_STATUS_BRICKS:-20}"

# ============================================================================
# READ INPUT & PARSE COMMON DATA
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
# INDIVIDUAL COMPONENT RENDERERS
# ============================================================================

render_powerline() {
    echo "$input" | bunx @owloops/claude-powerline@1.13.2 --style=minimal --theme=dark 2>/dev/null | tr -d '\n'
}

render_model() {
    local model=$(get_value model '.model.display_name' 'Claude' | sed 's/Claude //')
    echo -en "\033[1;36m[$model]\033[0m"
}

render_git() {
    compute_git
    [[ "${CACHE[in_git_repo]}" != "1" ]] && return

    local out="\033[1;32m${CACHE[repo_name]}\033[0m"
    [[ -n "${CACHE[branch]}" ]] && out+=":\033[1;34m${CACHE[branch]}\033[0m"

    if [[ -n "${CACHE[commit_short]}" ]]; then
        out+=" [\033[1;33m${CACHE[commit_short]}\033[0m]"
        [[ -n "${CACHE[commit_msg]}" ]] && out+=" ${CACHE[commit_msg]}"
    fi
    echo -en "$out"
}

render_github() {
    compute_git
    [[ -n "${CACHE[github_repo]}" ]] && echo -en "\033[0;35m${CACHE[github_repo]}\033[0m"
}

render_gitstatus() {
    compute_git
    [[ -n "${CACHE[git_status]}" ]] && echo -en "\033[1;31m${CACHE[git_status]}\033[0m"
}

render_lines() {
    local added=$(get_value lines_added '.cost.total_lines_added' '0')
    local removed=$(get_value lines_removed '.cost.total_lines_removed' '0')
    echo -en "\033[0;32m+${added}\033[0m/\033[0;31m-${removed}\033[0m"
}

render_bricks() {
    compute_context

    local used_bricks=$(( CACHE[total_tokens] > 0 ? (CACHE[used_tokens] * BRICK_COUNT) / CACHE[total_tokens] : 0 ))
    local free_bricks=$((BRICK_COUNT - used_bricks))

    local out="["
    for ((i=0; i<used_bricks; i++)); do out+="\033[0;36m■\033[0m"; done
    for ((i=0; i<free_bricks; i++)); do out+="\033[2;37m□\033[0m"; done
    out+="] \033[1m${CACHE[usage_pct]}%\033[0m (${CACHE[used_k]}k/${CACHE[total_k]}k)"

    echo -en "$out"
}

render_bricksfree() {
    compute_context
    echo -en "\033[1;32m${CACHE[free_k]}k free\033[0m"
}

render_duration() {
    local duration_ms=$(get_value duration_ms '.cost.total_duration_ms' '0')
    local hours=$((duration_ms / 3600000))
    local mins=$(((duration_ms % 3600000) / 60000))
    echo -en "${hours}h ${mins}m"
}

render_cost() {
    local cost=$(get_value cost '.cost.total_cost_usd' '0')

    local show_cost=0
    if command -v bc &> /dev/null; then
        (( $(echo "$cost > 0" | bc -l 2>/dev/null || echo "0") )) && show_cost=1
    else
        [[ "$cost" != "0" && "$cost" != "0.0" && "$cost" != "0.00" && -n "$cost" ]] && show_cost=1
    fi

    if [[ "$show_cost" == "1" ]]; then
        local formatted=$(printf "%.2f" "$cost" 2>/dev/null || echo "$cost")
        echo -en "\033[0;33m\$${formatted}\033[0m"
    fi
}

render_sep() {
    echo -en " \033[2m|\033[0m "
}

# ============================================================================
# PRE-COMPOSED LINE COMPONENTS
# ============================================================================

render_gitline() {
    compute_git
    local out=""

    # Model
    local model=$(get_value model '.model.display_name' 'Claude' | sed 's/Claude //')
    out+="\033[1;36m[$model]\033[0m "

    # Repo:Branch
    if [[ "${CACHE[in_git_repo]}" == "1" ]]; then
        out+="\033[1;32m${CACHE[repo_name]}\033[0m"
        [[ -n "${CACHE[branch]}" ]] && out+=":\033[1;34m${CACHE[branch]}\033[0m"

        # Commit
        if [[ -n "${CACHE[commit_short]}" ]]; then
            out+=" [\033[1;33m${CACHE[commit_short]}\033[0m]"
            [[ -n "${CACHE[commit_msg]}" ]] && out+=" ${CACHE[commit_msg]}"
        fi

        # GitHub
        [[ -n "${CACHE[github_repo]}" ]] && out+=" | \033[0;35m${CACHE[github_repo]}\033[0m"

        # Git status
        [[ -n "${CACHE[git_status]}" ]] && out+=" \033[1;31m${CACHE[git_status]}\033[0m"
    fi

    # Lines changed
    local added=$(get_value lines_added '.cost.total_lines_added' '0')
    local removed=$(get_value lines_removed '.cost.total_lines_removed' '0')
    if [[ "$added" -gt 0 || "$removed" -gt 0 ]]; then
        out+=" | \033[0;32m+${added}\033[0m/\033[0;31m-${removed}\033[0m"
    fi

    echo -en "$out"
}

render_bricksline() {
    compute_context

    # Bricks visualization
    local used_bricks=$(( CACHE[total_tokens] > 0 ? (CACHE[used_tokens] * BRICK_COUNT) / CACHE[total_tokens] : 0 ))
    local free_bricks=$((BRICK_COUNT - used_bricks))

    local out="["
    for ((i=0; i<used_bricks; i++)); do out+="\033[0;36m■\033[0m"; done
    for ((i=0; i<free_bricks; i++)); do out+="\033[2;37m□\033[0m"; done
    out+="] \033[1m${CACHE[usage_pct]}%\033[0m (${CACHE[used_k]}k/${CACHE[total_k]}k)"

    # Free space
    out+=" | \033[1;32m${CACHE[free_k]}k free\033[0m"

    # Duration
    local duration_ms=$(get_value duration_ms '.cost.total_duration_ms' '0')
    local hours=$((duration_ms / 3600000))
    local mins=$(((duration_ms % 3600000) / 60000))
    out+=" | ${hours}h ${mins}m"

    # Lines
    local added=$(get_value lines_added '.cost.total_lines_added' '0')
    local removed=$(get_value lines_removed '.cost.total_lines_removed' '0')
    out+=" | \033[0;32m+${added}\033[0m/\033[0;31m-${removed}\033[0m"

    # Cost (if non-zero)
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
# LAYOUT ENGINE
# ============================================================================

render_component() {
    local component="$1"
    case "$component" in
        # Pre-composed lines
        gitline)     render_gitline ;;
        bricksline)  render_bricksline ;;
        powerline)   render_powerline ;;
        # Individual components
        model)       render_model ;;
        git)         render_git ;;
        github)      render_github ;;
        gitstatus)   render_gitstatus ;;
        lines)       render_lines ;;
        bricks)      render_bricks ;;
        bricksfree)  render_bricksfree ;;
        duration)    render_duration ;;
        cost)        render_cost ;;
        sep)         render_sep ;;
        *)           ;;
    esac
}

render_layout() {
    local layout="$1"
    local line=""
    local first_on_line=1

    for token in $layout; do
        if [[ "$token" == '\n' ]]; then
            [[ -n "$line" ]] && echo -e "$line"
            line=""
            first_on_line=1
        else
            local rendered=$(render_component "$token")
            if [[ -n "$rendered" ]]; then
                if [[ "$first_on_line" == "1" ]]; then
                    line="$rendered"
                    first_on_line=0
                elif [[ "$token" == "sep" ]]; then
                    line+="$rendered"
                else
                    line+=" $rendered"
                fi
            fi
        fi
    done

    [[ -n "$line" ]] && echo -e "$line"
}

# ============================================================================
# MAIN
# ============================================================================

render_layout "$LAYOUT"
