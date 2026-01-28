#!/usr/bin/env bash
#
# bootstrap.sh - Fresh macOS development environment setup
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/mujuni88/dev-env/main/bootstrap.sh | bash
#
# Or with options:
#   ./bootstrap.sh --no-ai        # Skip AI assistant installation
#   ./bootstrap.sh --claude       # Install Claude Code (non-interactive)
#   ./bootstrap.sh --opencode     # Install OpenCode (non-interactive)
#   ./bootstrap.sh --ai-only      # Skip prerequisites, just install AI tools

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================

REPO_URL="https://github.com/mujuni88/dev-env.git"
DEV_ENV_DIR="${MY_DEV:-$HOME/dev-env}"

# ==============================================================================
# Colors and Output
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✓${NC}  $*"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
error()   { echo -e "${RED}✗${NC}  $*" >&2; }
step()    { echo -e "\n${CYAN}▶${NC}  ${CYAN}$*${NC}"; }

# ==============================================================================
# Check Functions
# ==============================================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

xcode_clt_installed() {
    xcode-select -p >/dev/null 2>&1
}

nix_installed() {
    [ -d /nix ] && command_exists nix
}

bun_installed() {
    command_exists bun
}

homebrew_installed() {
    command_exists brew
}

claude_code_installed() {
    command_exists claude
}

opencode_installed() {
    command_exists opencode
}

# ==============================================================================
# Path Setup (avoid shell restart)
# ==============================================================================

setup_paths() {
    # Nix daemon
    if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi

    # Homebrew (Apple Silicon)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    # Homebrew (Intel)
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Bun
    export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Local bin
    export PATH="$HOME/.local/bin:$PATH"

    # npm global
    export PATH="$HOME/.npm-global/bin:$PATH"
}

# ==============================================================================
# Installation Functions
# ==============================================================================

install_xcode_clt() {
    step "Installing Xcode Command Line Tools"

    if xcode_clt_installed; then
        success "Xcode CLT already installed"
        return 0
    fi

    info "Triggering Xcode CLT installation..."
    xcode-select --install 2>/dev/null || true

    # Wait for installation to complete
    info "Waiting for Xcode CLT installation to complete..."
    info "Please follow the prompts in the dialog that appeared"

    until xcode_clt_installed; do
        sleep 5
    done

    success "Xcode CLT installed"
}

install_nix() {
    step "Installing Nix"

    if nix_installed; then
        success "Nix already installed"
        setup_paths
        return 0
    fi

    info "Installing Nix package manager..."
    sh <(curl -L https://nixos.org/nix/install)

    # Source nix daemon for current session
    setup_paths

    if nix_installed; then
        success "Nix installed successfully"
    else
        error "Nix installation failed"
        exit 1
    fi
}

install_bun() {
    step "Installing Bun"

    setup_paths

    if bun_installed; then
        success "Bun already installed"
        return 0
    fi

    info "Installing Bun runtime..."
    curl -fsSL https://bun.sh/install | bash

    # Update PATH for current session
    setup_paths

    if bun_installed; then
        success "Bun installed successfully"
    else
        error "Bun installation failed"
        exit 1
    fi
}

clone_repo() {
    step "Setting up dev-env repository"

    if [ -d "$DEV_ENV_DIR/.git" ]; then
        success "Repository already exists at $DEV_ENV_DIR"
        info "Pulling latest changes..."
        cd "$DEV_ENV_DIR"
        git pull || warn "Could not pull latest changes"
        return 0
    fi

    if [ -d "$DEV_ENV_DIR" ]; then
        warn "Directory exists but is not a git repo: $DEV_ENV_DIR"
        warn "Please remove or backup this directory and run again"
        exit 1
    fi

    info "Cloning repository..."
    git clone "$REPO_URL" "$DEV_ENV_DIR"
    success "Repository cloned to $DEV_ENV_DIR"
}

install_dependencies() {
    step "Installing workspace dependencies"

    cd "$DEV_ENV_DIR"

    if [ -f bun.lockb ] || [ -f package.json ]; then
        info "Running bun install..."
        bun install
        success "Dependencies installed"
    else
        warn "No package.json found, skipping bun install"
    fi
}

handle_etc_conflicts() {
    # nix-darwin won't overwrite existing /etc files - check and offer to remove them
    local conflicting_files=()
    local etc_files=("/etc/nix/nix.conf" "/etc/bashrc" "/etc/zshrc")

    for f in "${etc_files[@]}"; do
        if [ -f "$f" ]; then
            conflicting_files+=("$f")
        fi
    done

    if [ ${#conflicting_files[@]} -eq 0 ]; then
        return 0
    fi

    warn "Found files that nix-darwin needs to manage:"
    for f in "${conflicting_files[@]}"; do
        echo "      $f"
    done
    echo ""

    # Handle interactive vs non-interactive
    local response
    if [ -t 0 ]; then
        read -rp "  Remove these files to continue? [Y/n]: " response
    elif [ -e /dev/tty ]; then
        read -rp "  Remove these files to continue? [Y/n]: " response </dev/tty
    else
        response="y"
        info "Non-interactive mode, removing files automatically"
    fi

    if [[ "${response:-y}" =~ ^[Yy]?$ ]]; then
        for f in "${conflicting_files[@]}"; do
            sudo rm "$f"
            info "Removed $f"
        done
        success "Conflicting files removed"
    else
        error "Cannot proceed without removing these files"
        error "nix-darwin needs to manage /etc/bashrc, /etc/zshrc, and /etc/nix/nix.conf"
        exit 1
    fi
}

bootstrap_nix_darwin() {
    step "Bootstrapping nix-darwin"

    setup_paths

    # Check if nix-darwin is already bootstrapped
    if command_exists darwin-rebuild; then
        success "nix-darwin already bootstrapped"
        info "Running darwin-rebuild switch..."
        cd "$DEV_ENV_DIR/packages/nix"
        sudo darwin-rebuild switch --flake ".#macos"
        success "System configuration applied"
        return 0
    fi

    # First-time setup: check for /etc conflicts
    handle_etc_conflicts

    info "First-time nix-darwin bootstrap..."
    info "This requires sudo for system activation..."
    cd "$DEV_ENV_DIR/packages/nix"

    # Run the initial bootstrap command with sudo (required for system activation)
    sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake ".#macos"

    success "nix-darwin bootstrapped successfully"

    # Refresh paths after nix-darwin installs Homebrew
    setup_paths
}

install_claude_code() {
    step "Installing Claude Code"

    setup_paths

    if claude_code_installed; then
        success "Claude Code already installed"
        return 0
    fi

    info "Installing Claude Code..."

    # Try npm first (most reliable)
    if command_exists npm; then
        npm install -g @anthropic-ai/claude-code
    elif command_exists bun; then
        # Bun global install
        bun install -g @anthropic-ai/claude-code
    else
        error "No package manager available for Claude Code installation"
        error "Please install npm or bun first"
        return 1
    fi

    setup_paths

    if claude_code_installed; then
        success "Claude Code installed successfully"
    else
        error "Claude Code installation failed"
        return 1
    fi
}

install_opencode() {
    step "Installing OpenCode"

    setup_paths

    if opencode_installed; then
        success "OpenCode already installed"
        return 0
    fi

    # OpenCode should be installed via Homebrew (from nix-darwin config)
    if homebrew_installed; then
        info "Installing OpenCode via Homebrew..."
        brew install opencode-ai/tap/opencode
        setup_paths

        if opencode_installed; then
            success "OpenCode installed successfully"
        else
            error "OpenCode installation failed"
            return 1
        fi
    else
        error "Homebrew not available. OpenCode requires Homebrew."
        return 1
    fi
}

# ==============================================================================
# AI Assistant Selection
# ==============================================================================

prompt_ai_assistant() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  AI Assistant Selection${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Claude Code is recommended for completing the setup interactively."
    echo "  After bootstrap, you can run 'claude' and ask it to complete setup."
    echo ""
    echo "  1) Claude Code (recommended)"
    echo "  2) OpenCode"
    echo "  3) Both"
    echo "  4) Skip (manual setup)"
    echo ""

    # Read from /dev/tty to handle curl | bash case
    local choice
    if [ -t 0 ]; then
        # stdin is a terminal
        read -rp "  Select an option [1-4] (default: 1): " choice
    elif [ -e /dev/tty ]; then
        # stdin is piped, but tty is available
        read -rp "  Select an option [1-4] (default: 1): " choice </dev/tty
    else
        # Non-interactive, default to Claude Code
        info "Non-interactive mode detected, defaulting to Claude Code"
        choice="1"
    fi
    choice="${choice:-1}"

    case "$choice" in
        1)
            install_claude_code
            AI_TOOL="claude"
            ;;
        2)
            install_opencode
            AI_TOOL="opencode"
            ;;
        3)
            install_claude_code
            install_opencode
            AI_TOOL="claude"  # Default to claude for instructions
            ;;
        4)
            info "Skipping AI assistant installation"
            AI_TOOL=""
            ;;
        *)
            warn "Invalid choice, defaulting to Claude Code"
            install_claude_code
            AI_TOOL="claude"
            ;;
    esac
}

# ==============================================================================
# Print Final Instructions
# ==============================================================================

print_next_steps() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✓ Bootstrap Complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [ -n "${AI_TOOL:-}" ]; then
        echo -e "  ${YELLOW}Next Steps:${NC}"
        echo ""
        echo "  1. Start a new terminal (to load shell configuration)"
        echo ""
        echo "  2. Run the AI assistant to complete setup:"
        echo -e "     ${CYAN}cd ~/dev-env && $AI_TOOL${NC}"
        echo ""
        echo "  3. Tell the assistant:"
        echo -e "     ${CYAN}\"Complete my dev-env setup\"${NC}"
        echo ""
        echo "  The AI will run 'bun run setup' and handle any remaining"
        echo "  configuration interactively."
    else
        echo -e "  ${YELLOW}Next Steps (Manual):${NC}"
        echo ""
        echo "  1. Start a new terminal (to load shell configuration)"
        echo ""
        echo "  2. Complete the setup:"
        echo -e "     ${CYAN}cd ~/dev-env && bun run setup${NC}"
        echo ""
        echo "  This will:"
        echo "    • Install global Node.js tools"
        echo "    • Configure dotfiles and shell settings"
    fi

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ==============================================================================
# CLI Argument Parsing
# ==============================================================================

NO_AI=false
INSTALL_CLAUDE=false
INSTALL_OPENCODE=false
AI_ONLY=false
AI_TOOL=""

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --no-ai)
                NO_AI=true
                shift
                ;;
            --claude)
                INSTALL_CLAUDE=true
                shift
                ;;
            --opencode)
                INSTALL_OPENCODE=true
                shift
                ;;
            --ai-only)
                AI_ONLY=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --no-ai       Skip AI assistant installation"
                echo "  --claude      Install Claude Code (non-interactive)"
                echo "  --opencode    Install OpenCode (non-interactive)"
                echo "  --ai-only     Skip prerequisites, just install AI tools"
                echo "  --help, -h    Show this help message"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# ==============================================================================
# Main
# ==============================================================================

main() {
    parse_args "$@"

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  dev-env Bootstrap Script${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # AI-only mode: just install AI tools
    if [ "$AI_ONLY" = true ]; then
        setup_paths

        if [ "$INSTALL_CLAUDE" = true ]; then
            install_claude_code
            AI_TOOL="claude"
        fi
        if [ "$INSTALL_OPENCODE" = true ]; then
            install_opencode
            AI_TOOL="${AI_TOOL:-opencode}"
        fi
        if [ "$INSTALL_CLAUDE" = false ] && [ "$INSTALL_OPENCODE" = false ]; then
            prompt_ai_assistant
        fi

        print_next_steps
        return 0
    fi

    # Full bootstrap
    install_xcode_clt
    install_nix
    install_bun
    clone_repo
    install_dependencies
    bootstrap_nix_darwin

    # AI assistant selection
    if [ "$NO_AI" = true ]; then
        AI_TOOL=""
    elif [ "$INSTALL_CLAUDE" = true ]; then
        install_claude_code
        AI_TOOL="claude"
        if [ "$INSTALL_OPENCODE" = true ]; then
            install_opencode
        fi
    elif [ "$INSTALL_OPENCODE" = true ]; then
        install_opencode
        AI_TOOL="opencode"
    else
        # Interactive prompt
        prompt_ai_assistant
    fi

    print_next_steps
}

main "$@"
