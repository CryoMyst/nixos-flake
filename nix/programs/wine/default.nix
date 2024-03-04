{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.wine;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.wine = {
    enable = lib.mkEnableOption "Enable wine configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            winetricks
            wineWowPackages.stagingFull
          ];
        };
      };
    };
  };
}
