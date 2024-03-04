{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.looking-glass;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.looking-glass = {
    enable = lib.mkEnableOption "Enable looking-glass configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            looking-glass-client
          ];
        };
      };
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${cryo.username} kvm -"
    ];
  };
}
