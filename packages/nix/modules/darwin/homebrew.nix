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
    "nushell" # Modern shell alternative

    # Terminal multiplexers
    "tmux" # Terminal multiplexer
    "zellij" # Alternative terminal multiplexer with Rust

    # CLI tools and utilities
    "bat" # Better cat with syntax highlighting
    "ripgrep" # Fast text search
    "eza" # Modern ls replacement
    "tree" # Directory structure visualization
    "fd" # Better alternative to find
    "jq" # JSON processor
    "wget" # Command-line tool for downloading files

    # Development tools
    "jj" # A more improved Git
    "lazygit" # Terminal UI for git
    "commitizen" # Git commit conventions tool
    "gh" # Github CLI
    "neovim" # Text editor
    "git-delta" # Better git diff
    "lazydocker" # Terminal UI for docker
    "dotbot" # Dotfiles manager

    # Programming languages and runtimes
    "rustup" # Rust toolchain installer
    "deno" # JavaScript/TypeScript runtime
    "oven-sh/bun/bun" # JavaScript/TypeScript runtime
    "go" # Go programming language
    "fnm" # Fast Node version manager
    "node" # Node.js runtime (needed for LSP servers)
    "python" # Python runtime (needed for some LSP servers)
    "luarocks" # Lua package manager

    # AI tools
    "ollama" # Local LLMs

    # File management
    "yazi" # Terminal file manager

    # Yazi dependencies
    "ffmpeg" # Media processing
    "p7zip" # Archive handling
    "poppler" # PDF rendering
    "imagemagick" # Image processing

    # AI Terminal Apps
    "sst/tap/opencode" # Opencode
    "gemini-cli" # Gemini Cli
  ];

  casks = [
    # Terminal and Shell Tools
    "ghostty"
    "warp"
    "amazon-q"

    # Development
    "visual-studio-code"
    "sublime-text"
    "cursor" # Cursor IDE
    "windsurf"
    "ngrok"
    "temurin" # Eclipse Temurin OpenJDK distribution
    "docker" # Docker Desktop for macOS
    "repo-prompt"
    "figma"

    # Web Browsers
    "arc"
    "google-chrome"
    "firefox"
    "brave-browser"
    "thebrowsercompany-dia"

    # Communication Apps
    "slack"
    "discord"
    "whatsapp"
    "superwhisper"

    # Productivity Apps
    "notion"
    "raycast"
    "chatgpt"
    "claude"
    "claude-code" # Claude Code IDE
    "jordanbaird-ice"

    # Media and Entertainment
    "spotify"
    "iina"
    "notunes"

    # Utility Applications
    "appcleaner"
    "cleanshot"
    "loom"
    "muzzle"
    "canva"
    "grammarly-desktop"
    "clop"

    # Security and Privacy
    "nordvpn"

    # Finance and Cryptocurrency
    "ledger-live"

    # Keyboard/Navigation Management
    "karabiner-elements"
    "homerow"
    "bazecor" # Dygma Keyboard Configurator
  ];

  masApps = {
    "PastePal" = 1503446680;
    "Yoink" = 457622435;
    "SparkMailAI" = 6445813049;
  };
}
