{
  # Enable Homebrew support in the Nix configuration
  enable = true;

  # Automatically update Homebrew formulas on activation (when Nix configuration is applied)
  onActivation.autoUpdate = true;

  # Upgrade installed packages to their latest versions on activation
  onActivation.upgrade = true;

  # Set installation directories and disable quarantine
  caskArgs = {
    appdir = "~/Applications";
    fontdir = "~/Library/Fonts";
    no_quarantine = true;
  };

  # Use a global Brewfile to manage Homebrew dependencies across the system
  global.brewfile = true;

  # Cleanup Homebrew packages not in the config
  onActivation.cleanup = "uninstall";

  brews = [
    # Package manager and utilities
    "uv"
    "mas"
    "stow"
    "gnu-sed"
    
    # Shell and terminal enhancements
    "zsh"
    "zsh-syntax-highlighting"
    "zsh-autocomplete"
    "starship"   # Prompt customization
    "zoxide"     # Smart directory jumping
    "fzf"        # Fuzzy finder
    "atuin"      # Shell history manager
    "nushell"    # Modern shell alternative
    
    # Terminal multiplexers
    "tmux"       # Terminal multiplexer
    "zellij"     # Alternative terminal multiplexer with Rust
    
    # CLI tools and utilities
    "bat"        # Better cat with syntax highlighting
    "ripgrep"    # Fast text search
    "eza"        # Modern ls replacement
    "tree"       # Directory structure visualization
    "fd"         # Better alternative to find
    "jq"         # JSON processor
    
    # Development tools
    "lazygit"    # Terminal UI for git
    "gh"         # Github CLI
    "neovim"     # Text editor
    "git-delta"  # Better git diff
    "docker"     # Containerization
    "lazydocker" # Terminal UI for docker
    
    # Programming languages and runtimes
    "rustup"     # Rust toolchain installer
    "deno"       # JavaScript/TypeScript runtime
    "go"         # Go programming language
    "fnm"        # Fast Node version manager
    
    # AI tools
    "ollama"     # Local LLMs
    
    # File management
    "yazi"       # Terminal file manager
    
    # Yazi dependencies
    "ffmpeg"     # Media processing
    "p7zip"      # Archive handling
    "poppler"    # PDF rendering
    "imagemagick" # Image processing
  ];

  casks = [
    # Terminal and Shell Tools
    "ghostty"
    "warp"
    "amazon-q"

    # Window management
    # "nikitabobko/tap/aerospace"

    # Development
    "visual-studio-code"
    "sublime-text"
    "windsurf"
    "ngrok"

    # Web Browsers
    "arc"
    "google-chrome"
    "firefox"
    "brave-browser"

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

    # Media and Entertainment
    "spotify"
    "iina"

    # Utility Applications
    "appcleaner"
    "cleanshot"
    "loom"
    "muzzle"

    # Security and Privacy
    "nordvpn"

    # Finance and Cryptocurrency
    "ledger-live"

    # Keyboard Management
    "karabiner-elements"
    "homerow"
  ];

  masApps = {
    "Yoink" = 457622435;
    "SparkMail" = 1176895641;
  };
}
