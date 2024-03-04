{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.wayvnc;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.wayvnc = {
    enable = lib.mkEnableOption "Enable wayvnc configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            wayvnc
          ];
        };

        xdg.configFile.wayvnc = {
          source = ./wayvnc;
          recursive = true;
        };
      };
    };
  };
}
