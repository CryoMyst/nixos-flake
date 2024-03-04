{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.sound;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.sound = {
    enable = lib.mkEnableOption "Enable sound support";
  };

  config = lib.mkIf isEnabled {
    sound.enable = true;
    hardware = {
      pulseaudio.enable = false;
    };

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };
  };
}
