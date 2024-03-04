{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.services.ssh;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.services.ssh = {
    enable = lib.mkEnableOption "Enable ssh service";
  };

  config = lib.mkIf isEnabled {
    services.openssh = {
      enable = true;

      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
