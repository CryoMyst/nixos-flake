{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.yubikey;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.yubikey = {
    enable = lib.mkEnableOption "Enable yubikey support";
  };

  config = lib.mkIf isEnabled {
    services.udev.packages = [pkgs.yubikey-personalization];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.pcscd.enable = true;
  };
}
