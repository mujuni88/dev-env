{pkgs, ...}: let
  # Define variables for reuse
  user = "jbuza";

  # Import system packages and homebrew configurations
  packages = import ./packages.nix {inherit pkgs;};
  homebrewConfig = import ./homebrew.nix;
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = packages;

  # Homebrew configuration
  homebrew = homebrewConfig;

  # System configurations
  system = {
    primaryUser = user; # Set the primary user for nix-darwin
    stateVersion = 5; # Match the version in system.nix

    # Configure trackpad behavior
    activationScripts.postActivation.text = ''
      # Load trackpad settings
      defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    '';

    # Import system defaults from system.nix
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 1.0;
        orientation = "bottom";
        show-recents = false;
        launchanim = true;
        tilesize = 48;
        persistent-apps = [
          "/System/Applications/iPhone Mirroring.app"
          "/Users/jbuza/Applications/AppCleaner.app"
          "/Applications/Spark Desktop.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Messages.app"
          "/Users/jbuza/Applications/Slack.app"
          "/Users/jbuza/Applications/Arc.app"
          "/Applications/Comet.app"
          "/Users/jbuza/Applications/Notion.app"
          "/Applications/Cursor.app"
          "/Users/jbuza/Applications/Zed.app"
        ];
      };

      # Finder settings
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
      };

      # Screensaver settings
      screensaver = {
        askForPasswordDelay = 10;
      };

      # Global macOS settings
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 3;
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  # Font packages
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Environment variables
  environment = {
    systemPath = ["/opt/homebrew/bin"];
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  security.sudo.extraConfig = ''
    jbuza ALL=(ALL) NOPASSWD: ALL
  '';

  # Nix flakes settings
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Platform configuration for Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User configuration
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
}
