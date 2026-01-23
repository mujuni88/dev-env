{pkgs, lib, ...}: let
  # Define variables for reuse
  user = "jbuza";

  # Import system packages and homebrew configurations
  packages = import ./packages.nix {inherit pkgs;};
  homebrewConfig = import ./homebrew.nix;

  # Custom packages
  kanata-cmd = pkgs.callPackage ./kanata.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = packages ++ [kanata-cmd];

  # Karabiner VirtualHIDDevice daemon (required for Kanata)
  launchd.daemons.karabiner-vhid = {
    serviceConfig = {
      Label = "org.pqrs.Karabiner-VirtualHIDDevice-Daemon";
      ProgramArguments = [
        "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      StandardOutPath = "/tmp/karabiner-vhid.out.log";
      StandardErrorPath = "/tmp/karabiner-vhid.err.log";
    };
  };

  # Kanata keyboard remapper daemon
  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "com.github.jtroo.kanata";
      ProgramArguments = [
        "/run/current-system/sw/bin/kanata"
        "--cfg"
        "/Users/${user}/.config/kanata/kanata.kbd"
      ];
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;  # Only restart on crashes, not clean exits
      };
      ThrottleInterval = 5;  # Wait 5s between retries (gives VirtualHID time to start)
      StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
      StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
      UserName = "root";
    };
  };

  # Homebrew configuration
  homebrew = homebrewConfig;

  # System configurations
  system = {
    primaryUser = user; # Set the primary user for nix-darwin
    stateVersion = 5; # Match the version in system.nix

    # Configure trackpad behavior and install Karabiner DriverKit
    activationScripts.postActivation.text = ''
      # Create Kanata log directory
      mkdir -p /Library/Logs/Kanata

      # Load trackpad settings
      defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

      # Don't reopen apps on login
      defaults write com.apple.loginwindow TALLogoutSavesState -bool false

      # Install Karabiner DriverKit VirtualHIDDevice for Kanata support
      KARABINER_DK="${pkgs.karabiner-dk}"
      
      # Copy Manager app to /Applications (requires sudo, handled by activation)
      if [ -d "$KARABINER_DK/Applications/.Karabiner-VirtualHIDDevice-Manager.app" ]; then
        rm -rf "/Applications/.Karabiner-VirtualHIDDevice-Manager.app"
        cp -R "$KARABINER_DK/Applications/.Karabiner-VirtualHIDDevice-Manager.app" "/Applications/"
        echo "Installed Karabiner-VirtualHIDDevice-Manager.app"
      fi
      
      # Copy Library support files
      if [ -d "$KARABINER_DK/Library/Application Support/org.pqrs" ]; then
        mkdir -p "/Library/Application Support/org.pqrs"
        rm -rf "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
        cp -R "$KARABINER_DK/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice" "/Library/Application Support/org.pqrs/"
        echo "Installed Karabiner DriverKit support files"
      fi
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
          "/Applications/Spark.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Messages.app"
          "/Users/jbuza/Applications/Slack.app"
          "/Users/jbuza/Applications/Arc.app"
          "/Users/jbuza/Applications/Notion.app"
          "/Applications/Cursor.app"
          "/Applications/IntelliJ IDEA.app"
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
