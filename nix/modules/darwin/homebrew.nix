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
    "uv"
    "mas"
    "zsh"
    "zsh-syntax-highlighting"
    "zsh-autocomplete"
    "stow"
    "tmux"
    "starship"
    "zoxide"
    "fzf"
    "atuin"
    "gnu-sed"
    "bat"
    "ripgrep"
    "lazygit"
    "neovim"
    "git-delta"
    "docker"
    "rustup"
    "deno"
    "eza"
    "go"
    "tree"
    "fnm"
    "nushell"

    # Yazi and its dependencies
    "yazi"
    "ffmpeg"
    "p7zip"
    "jq"
    "poppler"
    "fd" # A better alternative to find
    "imagemagick"
    #--- Yazi

    "lazydocker"
    "ollama"
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
