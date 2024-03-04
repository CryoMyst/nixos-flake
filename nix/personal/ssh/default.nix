{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}:
with lib; let
  cryo = config.cryo;
  cfg = config.cryo.personal.ssh;

  cryomyst-pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBcDtmczDm58vyrc+DkOnu9HzgSaZR7nwOjfK7nGx1Y CryoMyst@hotmail.com";
in {
  options.cryo.personal.ssh = {
    cryomyst = mkEnableOption "Add Cryomyst's public keys to authorized_keys";
  };

  config = mkIf cfg.cryomyst {
    users.users.${cryo.username}.openssh.authorizedKeys.keys = [
      cryomyst-pub
    ];
  };
}
