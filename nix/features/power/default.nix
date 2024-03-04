{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.power;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.power = {
    enable = lib.mkEnableOption "Enable power configuration";
    disablePowerButton = lib.mkEnableOption "Disable power button";
  };

  config = lib.mkIf isEnabled {
    services.logind.extraConfig =
      if cfg.disablePowerButton
      then ''
        # don’t shutdown when power button is short-pressed
        HandlePowerKey=ignore
      ''
      else '''';
  };
}
