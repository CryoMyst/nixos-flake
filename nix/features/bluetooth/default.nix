{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.bluetooth;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth support";
  };

  config = lib.mkIf isEnabled {
    services.blueman.enable = true;
    hardware = {
      enableAllFirmware = true;
      bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = true; # powers up the default Bluetooth controller on boot
        package = pkgs.bluez;
        settings = {
          General = {
            Name = cryo.hostname;
            ControllerMode = "dual";
            FastConnectable = "true";
            Experimental = "true";
          };
          Policy = {
            AutoEnable = "true";
          };
        };
      };
    };
  };
}
