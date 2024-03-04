{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.TODO;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.TODO = {
    enable = lib.mkEnableOption "Enable TODO";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
      };
    };
  };
}
