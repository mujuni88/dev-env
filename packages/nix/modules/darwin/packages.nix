{pkgs}:
with pkgs; [
  # Nix-specific tools
  alejandra # Nix code formatter
  kdlfmt # KDL code formatter

  # Keyboard drivers
  karabiner-dk # Virtual HID device driver for Kanata

  # Keep any other Nix-specific packages here that aren't available in Homebrew
]
