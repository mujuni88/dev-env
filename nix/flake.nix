{
  description = "Buza Darwin system flake";

  inputs = {
    # Nixpkgs - Unstable channel for the latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Nix-darwin - macOS system configuration
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew support via Nix
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Homebrew package repositories (core and cask)
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    nixpkgs,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
  }: let
    # Define variables to avoid repetition
    myMac = "macos";
    username = "jbuza";

    # Function for system configuration with darwin modules
    darwinSystem = {
      user,
      arch ? (
        if builtins.currentSystem == "aarch64-darwin"
        then "aarch64-darwin"
        else "x86_64-darwin"
      ),
    }:
      darwin.lib.darwinSystem {
        system = arch;
        modules = [
          ./modules/darwin/darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true; # Apple Silicon: Enable Intel binaries via Rosetta
              user = user;
              autoMigrate = true;
            };
          }
        ];
      };
  in {
    # System configurations using darwinSystem function
    darwinConfigurations = {
      "${myMac}" = darwinSystem {user = username;};
    };

    # Expose package set for reuse or overlays
    darwinPackages = self.darwinConfigurations."${myMac}".pkgs;
  };
}
