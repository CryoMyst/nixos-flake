{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.services.swayidle;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.services.swayidle = {
    enable = lib.mkEnableOption "Enable swayidle";

    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "The time in seconds before the screen locks";
    };
    lockCommand = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.swaylock}/bin/swaylock -f";
      description = "The command to run when locking the screen";
    };
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            swayidle
          ];
        };

        services = {
          swayidle = {
            enable = true;
            timeouts = [
              {
                timeout = cfg.lockTimeout;
                command = cfg.lockCommand;
              }
            ];
          };
        };
      };
    };
  };
}
