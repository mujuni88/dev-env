{pkgs, ...}: let
  # Define variables for reuse
  user = "jbuza";

  # Import system packages and homebrew configurations
  packages = import ./packages.nix {inherit pkgs;};
  systemConfig = import ./system.nix;
  homebrewConfig = import ./homebrew.nix;
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = packages;

  # Homebrew configuration
  homebrew = homebrewConfig;

  # System configurations
  system = {
    stateVersion = 5;  # Match the version in system.nix
    
    # Configure trackpad behavior
    activationScripts.postActivation.text = ''
      # Load trackpad settings
      defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    '';

    # Import system defaults from system.nix
    defaults = systemConfig;

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
    systemPath = [ "/opt/homebrew/bin" ];
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

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
