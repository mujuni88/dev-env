{
  # Enable Homebrew support in the Nix configuration
  enable = true;

  # Configure Homebrew activation behavior
  onActivation = {
    # Automatically update Homebrew formulas on activation
    autoUpdate = true;

    # Upgrade installed packages to their latest versions
    upgrade = true;

    # Cleanup Homebrew packages not in the config
    cleanup = "uninstall";
  };

  # Set installation directories and disable quarantine
  caskArgs = {
    appdir = "~/Applications";
    fontdir = "~/Library/Fonts";
    no_quarantine = true;
  };

  # Use a global Brewfile to manage Homebrew dependencies across the system
  global.brewfile = false;

  # Homebrew taps (third-party repositories)
  taps = [
    "withgraphite/tap"
    "anomalyco/tap"
    "dashlane/tap"
  ];

  brews = [
    # Package manager and utilities
    "uv"
    "mas"
    "gnu-sed"

    # Shell and terminal enhancements
    "zsh"
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-autocomplete"
    "carapace" # autcomplete
    "starship" # Prompt customization
    "zoxide" # Smart directory jumping
    "fzf" # Fuzzy finder
    "atuin" # Shell history manager

    # Terminal multiplexers
    "tmux" # Terminal multiplexer
    "zellij" # Alternative terminal multiplexer with Rust

    # CLI tools and utilities
    "bat" # Better cat with syntax highlighting
    "pandoc" # Universal document converter
    "ripgrep" # Fast text search
    "eza" # Modern ls replacement
    "tree" # Directory structure visualization
    "tree-sitter" # Tree-sitter CLI for nvim-treesitter
    "fd" # Better alternative to find
    "jq" # JSON processor
    "yq" # YAML processor (jq for YAML)
    "curl" # Latest curl with WebSocket support
    "wget" # Command-line tool for downloading files
    "xh" # Friendly HTTP client (curl alternative)
    "websocat" # WebSocket CLI client (netcat for WebSockets)
    "dashlane/tap/dashlane-cli" # dashlane api

    # Development tools
    "jj" # A more improved Git
    "lazygit" # Terminal UI for git
    "gh" # Github CLI
    "withgraphite/tap/graphite" # Graphite CLI for stacked diffs
    "neovim" # Text editor
    "git-delta" # Better git diff
    "lazydocker" # Terminal UI for docker
    "dotbot" # Dotfiles manager
    "mprocs" # Run multiple commands in parallel

    # Programming languages and runtimes
    "rustup" # Rust toolchain installer
    "oven-sh/bun/bun" # JavaScript/TypeScript runtime
    "go" # Go programming language
    "fnm" # Fast Node version manager
    "node" # Node.js runtime (needed for LSP servers)
    "python" # Python runtime (needed for some LSP servers)
    "luarocks" # Lua package manager

    # File management
    "yazi" # Terminal file manager

    # Yazi dependencies
    "ffmpeg" # Media processing
    "p7zip" # Archive handling
    "poppler" # PDF rendering
    "imagemagick" # Image processing

    # AI Terminal Apps
    "anomalyco/tap/opencode" # Opencode (official)
    "beads" # Persistent issue tracker for AI coding agents

  ];

  casks = [
    # Terminal and Shell Tools
    "ghostty"

    # Development
    "sublime-text" # Text editor
    #"cursor"  Cursor IDE::NOTE:: using companies version /Applications/Cursor.app/
    "ngrok"
    # Java managed via SDKMAN (not Homebrew)
    "docker-desktop" # Docker Desktop for macOS

    # Web Browsers
    "arc"
    "google-chrome"
    "helium-browser"

    # Communication Apps
    "slack"
    "discord"
    "whatsapp"
    "superwhisper"
    "zoom" # Video conferencing

    # Productivity Apps
    "notion"
    "obsidian"
    "raycast"
    "chatgpt"
    "claude"
    "codex" # OpenAI Codex CLI (migrated to cask)
    "opencode-desktop" # OpenCode desktop client
    # "claude-code" # Claude Code IDE
    "jordanbaird-ice"

    # Media and Entertainment
    "spotify"
    "iina"
    "notunes"

    # Utility Applications
    "appcleaner"
    "cleanshot"
    "canva"
    "grammarly-desktop"
    "clop"
    "logi-options+" # Logitech mouse/keyboard customization

    # Security and Privacy
    "nordvpn"

    # Finance and Cryptocurrency
    "ledger-wallet"

    # Keyboard/Navigation Management
    "homerow"
    "bazecor" # Dygma Keyboard Configurator
  ];

  masApps = {
    "Dashlane" = 517914548;
    "PastePal" = 1503446680;
    "Yoink" = 457622435;
    "SparkClassicEmailApp" = 1176895641;
  };
}
