{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.alacritty;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            alacritty
          ];
        };

        programs.alacritty = {
          enable = true;
          settings = {
            colors = {
              primary = {
                background = "0x000000";
              };
            };
          };
        };
      };
    };
  };
}
