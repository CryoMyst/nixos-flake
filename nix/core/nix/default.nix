{
  lib,
  pkgs,
  config,
  home-manager,
  rust-overlay,
  nixpkgs,
  nixpkgs-stable,
  nixpkgs-unstable,
  nixpkgs-master,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.core.nix;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.core.nix = {
    enable = lib.mkEnableOption "Enable base nix system";
  };

  config = lib.mkIf isEnabled {
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        sandbox = true;
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = ["04:00"];
      };
    };

    system.stateVersion = cryo.stateVersion;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
      overlays =
        [
          rust-overlay.overlays.default
        ]
        ++ (import ./../../overlays {inherit pkgs lib nixpkgs nixpkgs-stable nixpkgs-unstable nixpkgs-master;});
    };
  };
}
