{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.locale;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.locale = {
    enable = lib.mkEnableOption "Enable TODO";
    localeName = lib.mkOption {
      type = lib.types.str;
      default = "en_AU.UTF-8";
      description = "The locale to use";
    };
  };

  config = lib.mkIf isEnabled {
    time.timeZone = "Australia/Brisbane";
    i18n = {
      defaultLocale = "en_AU.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
      };
    };
  };
}
