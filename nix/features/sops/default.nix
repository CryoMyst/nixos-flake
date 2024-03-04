{
  lib,
  pkgs,
  config,
  home-manager,
  sops-nix,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.sops;
  isEnabled = cfg.enable && cryo.enable;
in {
    imports = [
        sops-nix.nixosModules.sops
    ];

  options.cryo.features.sops = {
    enable = lib.mkEnableOption "Enable sops";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        imports = [
            sops-nix.homeManagerModules.sops
        ];
      };
    };
  };
}
