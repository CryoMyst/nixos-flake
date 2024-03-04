{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.core.user;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.core.user = {
    enable = lib.mkEnableOption "Enable user configuration";
  };

  config = lib.mkIf isEnabled {
    users.groups = {
      "flakemanager" = {};
    };
    users.users = {
      ${cryo.username} = {
        isNormalUser = true;
        description = "${cryo.username}";
        extraGroups = ["flakemanager" "wheel"];
      };
    };
  };
}
