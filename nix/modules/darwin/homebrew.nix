{
  # Enable Homebrew support in the Nix configuration
  enable = true;

  # Automatically update Homebrew formulas on activation (when Nix configuration is applied)
  onActivation.autoUpdate = true;

  # Upgrade installed packages to their latest versions on activation
  onActivation.upgrade = true;

  # Disable macOS quarantine for apps installed via Homebrew casks (avoids "App can't be opened" warnings)
  caskArgs.no_quarantine = true;

  # Use a global Brewfile to manage Homebrew dependencies across the system
  global.brewfile = true;

  # Cleanup Homebrew packages not in the config
  # onActivation.cleanup = "uninstall";

  brews = [
    "mas"
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
    "go"
    "tree"
    "fnm"
  ];

  casks = [
    # Terminal and Shell Tools
    "ghostty"

    # Code Editors and IDEs
    "visual-studio-code"
    "sublime-text"
    "windsurf"

    # Web Browsers
    "arc"
    "google-chrome"
    "firefox"
    "brave-browser"

    # Communication Apps
    "slack"
    "discord"
    "whatsapp"

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
    "ngrok"

    # Added Karabiner Elements
    "karabiner-elements"
  ];

  masApps = {
    "Yoink" = 457622435;
    "EdisonMail" = 1489591003;
    "SparkMail" = 1176895641;
  };
}
