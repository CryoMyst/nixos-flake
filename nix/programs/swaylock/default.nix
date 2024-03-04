{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.swaylock;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.swaylock = {
    enable = lib.mkEnableOption "Enable swaylock configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            swaylock
          ];
        };

        programs = {
          swaylock = {
            enable = true;
            settings = {
              color = "#000000";
              show-failed-attempts = true;
            };
          };
        };
      };
    };

    security = {
      pam = {
        services = {
          swaylock = {
            text = ''
              auth include login
            '';
          };
        };
      };
    };
  };
}
