{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.i3status;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.i3status = {
    enable = lib.mkEnableOption "Enable i3status configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        programs = {
          i3status = {
            enable = true;
            enableDefault = false;

            general = {
              colors = true;
              interval = 5;
            };

            modules = {
              "disk /" = {
                position = 1;
                settings = {format = "%avail";};
              };

              "load" = {
                position = 2;
                settings = {format = "%1min";};
              };

              "memory" = {
                position = 3;
                settings = {
                  format = "%used/%available";
                  threshold_degraded = "1G";
                  format_degraded = "MEMORY < %available";
                };
              };

              "tztime local" = {
                position = 100;
                settings = {format = "%Y-%m-%d %H:%M:%S";};
              };
            };
          };
        };
      };
    };
  };
}
