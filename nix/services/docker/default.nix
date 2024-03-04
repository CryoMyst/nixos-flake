{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.services.docker;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.services.docker = {
    enable = lib.mkEnableOption "Enable docker service";
    nvidia = lib.mkEnableOption "Enable nvidia support";
  };

  config = lib.mkIf isEnabled {
    users.users = {
      ${cryo.username} = {
        extraGroups = ["docker"];
      };
    };

    virtualisation = {
      docker = {
        enable = true;
        enableNvidia = cfg.nvidia;
        logDriver = "json-file";
      };
    };
  };
}
