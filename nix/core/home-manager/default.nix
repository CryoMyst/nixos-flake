{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.core.home-manager;
  isEnabled = cfg.enable && cryo.enable;
in {
  imports = [
    home-manager.nixosModules.home-manager
    (import "${home-manager}/nixos")
  ];

  options.cryo.core.home-manager = {
    enable = lib.mkEnableOption "Enable base home-manager configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    home-manager.users = {
      ${cryo.username} = {
        home = {
          stateVersion = cryo.stateVersion;
        };
      };
    };
  };
}
