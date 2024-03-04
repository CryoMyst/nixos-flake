{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}:
with lib; let
  cryo = config.cryo;
  cfg = config.cryo.personal.shares;
in {
  options.cryo.personal.shares = {
    ram = mkEnableOption "Enable ram share";
    rem = mkEnableOption "Enable rem share";
  };

  config =
    mkIf cfg.ram {
      fileSystems."/mnt/ram" = {
        device = "nas.cryo.red:/ram";
        fsType = "nfs";
        options = "nobootwait";
      };
    }
    // mkIf cfg.rem {
      fileSystems."/mnt/rem" = {
        device = "nas.cryo.red:/rem";
        fsType = "nfs";
        options = "nobootwait";
      };
    };
}
