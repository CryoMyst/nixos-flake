{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo;
in {
  imports = [
    ./core
    ./features
    ./packages
    ./personal
    ./programs
    ./services
    ./setups
  ];

  options.cryo = {
    enable = lib.mkEnableOption "Enable the cryo module.";
    username = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The main username to use.";
    };
    hostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The computer hostname identifier.";
    };
    stateVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The state version to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.username != null;
        message = "cryo.username must be set to use the cryo module.";
      }
      {
        assertion = cfg.hostname != null;
        message = "cryo.hostname must be set to use the cryo module.";
      }
      {
        assertion = cfg.stateVersion != null;
        message = "cryo.stateVersion must be set to use the cryo module.";
      }
    ];

    cryo.core.nix.enable = true;
    cryo.core.home-manager.enable = true;
    cryo.core.user.enable = true;
  };
}
