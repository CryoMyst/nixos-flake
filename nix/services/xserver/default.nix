{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.services.xserver;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.services.xserver = {
    enable = lib.mkEnableOption "Enable xserver service";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          # Utility packages
          packages = with pkgs; [
            xorg.xhost
            xorg.xkill
          ];
        };
      };
    };
    services = {
      xserver = {
        enable = true;
        enableTCP = true;
        exportConfiguration = true;
        libinput.enable = true;
        logFile = "/var/log/Xorg.0.log";
        # verbose = 7;
      };
    };
  };
}
