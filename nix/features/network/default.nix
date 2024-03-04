{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.network;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.network = {
    enable = lib.mkEnableOption "Enable network features";
  };

  config = lib.mkIf isEnabled {
    networking = {
      firewall.enable = true;
      hostName = cryo.hostname;
      networkmanager.enable = true;
    };

    users.users = {
      ${cryo.username} = {
        extraGroups = [
          "networkmanager"
        ];
      };
    };
  };
}
