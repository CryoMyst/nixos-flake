# telegram-desktop
# teamspeak_client
# discord
{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.setups.social;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.setups.social = {
    enable = lib.mkEnableOption "Enable social setup";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages =
            (lib.optionals true [
              pkgs.telegram-desktop
            ])
            ++ (lib.optionals (pkgs.system == "x86_64-linux") [
              pkgs.teamspeak_client
              pkgs.discord
            ]);
        };
      };
    };
  };
}
