{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.services.strongswan;
  isEnabled = cfg.enable && cryo.enable;

  readJsonConfig = file: builtins.fromJSON (builtins.readFile file);
in {
  options.cryo.services.strongswan = {
    enable = lib.mkEnableOption "Enable strongswan service";
    externalJson = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Path to merge into the strongswan configuration";
    };
  };

  config = lib.mkIf isEnabled {
    networking.networkmanager.enableStrongSwan = true;
    services.strongswan =
      (
        if cfg.externalJson != "" && builtins.pathExists cfg.externalJson
        then readJsonConfig cfg.externalJson
        else {}
      )
      // {enable = true;};

    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            strongswan
            openssl
            networkmanager
          ];
        };
      };
    };
  };
}
