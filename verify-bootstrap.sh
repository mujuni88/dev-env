#!/usr/bin/env bash
#
# verify-bootstrap.sh - Verify dev-env bootstrap completed successfully
#
# Usage:
#   ./verify-bootstrap.sh           # Run all checks
#   ./verify-bootstrap.sh --verbose # Show detailed output
#   ./verify-bootstrap.sh --fix     # Suggest fix commands for failures
#
# Exit codes:
#   0 - All checks passed
#   1 - One or more checks failed

set -uo pipefail

# ==============================================================================
# Configuration
# ==============================================================================

DEV_ENV_DIR="${MY_DEV:-$HOME/dev-env}"
VERBOSE=false
SHOW_FIX=false

# ==============================================================================
# Colors and Output
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

pass()    { echo -e "  ${GREEN}✓${NC}  $*"; }
fail()    { echo -e "  ${RED}✗${NC}  $*"; }
warn()    { echo -e "  ${YELLOW}⚠${NC}  $*"; }
info()    { echo -e "  ${BLUE}ℹ${NC}  $*"; }
detail()  { $VERBOSE && echo -e "      ${DIM}$*${NC}"; }
fix()     { $SHOW_FIX && echo -e "      ${CYAN}Fix: $*${NC}"; }

# ==============================================================================
# Test Tracking
# ==============================================================================

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNED=0

record_pass() {
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
}

record_fail() {
    ((TESTS_RUN++))
    ((TESTS_FAILED++))
}

record_warn() {
    ((TESTS_RUN++))
    ((TESTS_WARNED++))
}

# ==============================================================================
# Check Functions
# ==============================================================================

check_xcode_clt() {
    echo ""
    echo -e "${CYAN}Xcode Command Line Tools${NC}"

    if xcode-select -p >/dev/null 2>&1; then
        local path
        path=$(xcode-select -p)
        pass "Installed"
        detail "Path: $path"
        record_pass
    else
        fail "Not installed"
        fix "xcode-select --install"
        record_fail
    fi
}

check_nix() {
    echo ""
    echo -e "${CYAN}Nix Package Manager${NC}"

    # Check /nix directory exists
    if [ -d /nix ]; then
        pass "/nix directory exists"
        record_pass
    else
        fail "/nix directory missing"
        fix "sh <(curl -L https://nixos.org/nix/install)"
        record_fail
        return
    fi

    # Check nix command available
    if command -v nix >/dev/null 2>&1; then
        local version
        version=$(nix --version 2>/dev/null || echo "unknown")
        pass "nix command available"
        detail "Version: $version"
        record_pass
    else
        fail "nix command not in PATH"
        fix "Source: . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        record_fail
    fi

    # Check nix-daemon running (socket is most reliable non-privileged check)
    if [ -S /nix/var/nix/daemon-socket/socket ]; then
        pass "nix-daemon socket active"
        record_pass
    elif pgrep -x nix-daemon >/dev/null 2>&1; then
        pass "nix-daemon process running"
        record_pass
    else
        warn "nix-daemon may not be running"
        fix "sudo launchctl kickstart -k system/org.nixos.nix-daemon"
        record_warn
    fi
}

check_bun() {
    echo ""
    echo -e "${CYAN}Bun Runtime${NC}"

    if command -v bun >/dev/null 2>&1; then
        local version
        version=$(bun --version 2>/dev/null || echo "unknown")
        pass "bun command available"
        detail "Version: $version"
        record_pass
    else
        fail "bun not installed"
        fix "curl -fsSL https://bun.sh/install | bash"
        record_fail
    fi
}

check_repo() {
    echo ""
    echo -e "${CYAN}Repository${NC}"

    # Check directory exists
    if [ -d "$DEV_ENV_DIR" ]; then
        pass "Directory exists: $DEV_ENV_DIR"
        record_pass
    else
        fail "Directory missing: $DEV_ENV_DIR"
        fix "git clone https://github.com/mujuni88/dev-env.git $DEV_ENV_DIR"
        record_fail
        return
    fi

    # Check it's a git repo
    if [ -d "$DEV_ENV_DIR/.git" ]; then
        pass "Is a git repository"
        record_pass

        # Check remote
        local remote
        remote=$(git -C "$DEV_ENV_DIR" remote get-url origin 2>/dev/null || echo "none")
        detail "Remote: $remote"
    else
        fail "Not a git repository"
        record_fail
    fi

    # Check key files exist
    local key_files=("package.json" "turbo.json" "bootstrap.sh" "verify-bootstrap.sh" "CLAUDE.md")
    local missing=()

    for file in "${key_files[@]}"; do
        if [ ! -f "$DEV_ENV_DIR/$file" ]; then
            missing+=("$file")
        fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
        pass "Key files present"
        record_pass
    else
        fail "Missing files: ${missing[*]}"
        record_fail
    fi
}

check_dependencies() {
    echo ""
    echo -e "${CYAN}Workspace Dependencies${NC}"

    if [ ! -d "$DEV_ENV_DIR" ]; then
        fail "Repository not found, skipping"
        record_fail
        return
    fi

    # Check node_modules exists
    if [ -d "$DEV_ENV_DIR/node_modules" ]; then
        local count
        count=$(find "$DEV_ENV_DIR/node_modules" -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
        pass "node_modules exists ($count packages)"
        record_pass
    else
        fail "node_modules missing"
        fix "cd $DEV_ENV_DIR && bun install"
        record_fail
    fi

    # Check bun.lockb exists (indicates bun install was run)
    if [ -f "$DEV_ENV_DIR/bun.lockb" ]; then
        pass "bun.lockb exists"
        record_pass
    else
        warn "bun.lockb missing (dependencies may not be locked)"
        record_warn
    fi
}

check_nix_darwin() {
    echo ""
    echo -e "${CYAN}nix-darwin${NC}"

    # Check darwin-rebuild command
    if command -v darwin-rebuild >/dev/null 2>&1; then
        pass "darwin-rebuild available"
        record_pass
    else
        fail "darwin-rebuild not available"
        detail "nix-darwin may not be bootstrapped yet"
        fix "cd $DEV_ENV_DIR/packages/nix && nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake '.#macos'"
        record_fail
        return
    fi

    # Check current generation
    if [ -L /run/current-system ]; then
        local gen
        gen=$(readlink /run/current-system 2>/dev/null || echo "unknown")
        pass "System generation active"
        detail "Generation: $gen"
        record_pass
    else
        warn "No active system generation found"
        record_warn
    fi
}

check_homebrew() {
    echo ""
    echo -e "${CYAN}Homebrew${NC}"

    if command -v brew >/dev/null 2>&1; then
        local version prefix
        version=$(brew --version 2>/dev/null | head -1 || echo "unknown")
        prefix=$(brew --prefix 2>/dev/null || echo "unknown")
        pass "brew command available"
        detail "Version: $version"
        detail "Prefix: $prefix"
        record_pass
    else
        fail "Homebrew not installed"
        detail "Should be installed by nix-darwin with nix-homebrew"
        fix "Run nix-darwin rebuild: darwin-rebuild switch --flake $DEV_ENV_DIR/packages/nix#macos"
        record_fail
    fi
}

check_shell_env() {
    echo ""
    echo -e "${CYAN}Shell Environment${NC}"

    # Check MY_DEV
    if [ -n "${MY_DEV:-}" ]; then
        pass "MY_DEV is set: $MY_DEV"
        record_pass
    else
        warn "MY_DEV not set (may need new terminal)"
        fix "export MY_DEV=$HOME/dev-env"
        record_warn
    fi

    # Check MY_NIX
    if [ -n "${MY_NIX:-}" ]; then
        pass "MY_NIX is set: $MY_NIX"
        record_pass
    else
        warn "MY_NIX not set (may need new terminal)"
        fix "export MY_NIX=\$MY_DEV/packages/nix"
        record_warn
    fi

    # Check PATH includes important directories
    local important_paths=(
        "$HOME/.bun/bin"
        "/opt/homebrew/bin"
        "$HOME/.nix-profile/bin"
    )

    for p in "${important_paths[@]}"; do
        if [[ ":$PATH:" == *":$p:"* ]]; then
            pass "PATH includes: $p"
            record_pass
        elif [ -d "$p" ]; then
            warn "PATH missing: $p (directory exists)"
            record_warn
        else
            detail "PATH missing: $p (directory doesn't exist, OK)"
        fi
    done
}

check_dotfiles() {
    echo ""
    echo -e "${CYAN}Dotfiles${NC}"

    # Check common symlinks
    local symlinks=(
        "$HOME/.config/nvim:nvim"
        "$HOME/.config/ghostty:ghostty"
        "$HOME/.config/starship.toml:starship"
        "$HOME/.gitconfig:git"
        "$HOME/.zshrc:zsh"
    )

    local linked=0
    local missing=0

    for item in "${symlinks[@]}"; do
        local path="${item%%:*}"
        local name="${item##*:}"

        if [ -L "$path" ]; then
            ((linked++))
            detail "Linked: $name → $(readlink "$path")"
        elif [ -e "$path" ]; then
            detail "Exists (not symlink): $name"
        else
            ((missing++))
            detail "Missing: $name"
        fi
    done

    if [ $linked -gt 0 ]; then
        pass "Dotfiles configured ($linked symlinks found)"
        record_pass
    else
        warn "No dotfile symlinks found"
        detail "Run: cd $DEV_ENV_DIR && bun run dotfiles-install"
        record_warn
    fi
}

check_ai_tools() {
    echo ""
    echo -e "${CYAN}AI Tools (Optional)${NC}"

    # Claude Code
    if command -v claude >/dev/null 2>&1; then
        pass "Claude Code installed"
        record_pass
    else
        info "Claude Code not installed (optional)"
    fi

    # OpenCode
    if command -v opencode >/dev/null 2>&1; then
        pass "OpenCode installed"
        record_pass
    else
        info "OpenCode not installed (optional)"
    fi
}

# ==============================================================================
# Summary
# ==============================================================================

print_summary() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  Summary${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "  Tests run:    $TESTS_RUN"
    echo -e "  ${GREEN}Passed:${NC}       $TESTS_PASSED"
    if [ $TESTS_WARNED -gt 0 ]; then
        echo -e "  ${YELLOW}Warnings:${NC}     $TESTS_WARNED"
    fi
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "  ${RED}Failed:${NC}       $TESTS_FAILED"
    fi

    echo ""

    if [ $TESTS_FAILED -eq 0 ]; then
        if [ $TESTS_WARNED -eq 0 ]; then
            echo -e "  ${GREEN}✓ All checks passed!${NC}"
        else
            echo -e "  ${YELLOW}⚠ Passed with warnings${NC}"
            echo -e "  ${DIM}  Some items may need attention or a new terminal session${NC}"
        fi
        echo ""
        return 0
    else
        echo -e "  ${RED}✗ Some checks failed${NC}"
        echo ""
        if $SHOW_FIX; then
            echo -e "  ${DIM}Fix commands shown above for each failure${NC}"
        else
            echo -e "  ${DIM}Run with --fix to see suggested fix commands${NC}"
        fi
        echo ""
        return 1
    fi
}

# ==============================================================================
# CLI Argument Parsing
# ==============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --fix|-f)
                SHOW_FIX=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Verify that dev-env bootstrap completed successfully."
                echo ""
                echo "Options:"
                echo "  --verbose, -v   Show detailed output for each check"
                echo "  --fix, -f       Show fix commands for failures"
                echo "  --help, -h      Show this help message"
                echo ""
                echo "Exit codes:"
                echo "  0  All checks passed"
                echo "  1  One or more checks failed"
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
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
    echo -e "${CYAN}  dev-env Bootstrap Verification${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Run all checks
    check_xcode_clt
    check_nix
    check_bun
    check_repo
    check_dependencies
    check_nix_darwin
    check_homebrew
    check_shell_env
    check_dotfiles
    check_ai_tools

    # Print summary and exit with appropriate code
    print_summary
}

main "$@"
