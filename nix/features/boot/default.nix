{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.boot;
  isEnabled = cfg.enable && cryo.enable;

  boolToIntMap = {
    true = "1";
    false = "0";
  };
  fnModeMap = {
    "disabled" = "0";
    "media" = "1";
    "function" = "2";
    "auto" = "3";
  };
in {
  options.cryo.features.boot = {
    enable = lib.mkEnableOption "Enable boot configuration";
    kernelParams = {
      appleShowNotch = lib.mkOption {
        # https://wiki.archlinux.org/title/Apple_Keyboard
        # show_notches - Show notches on the touchbar
        #     0 - disabled
        #     1 - enabled
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Show notches on the touchbar";
      };
      appleFnMode = lib.mkOption {
        # https://wiki.archlinux.org/title/Apple_Keyboard
        # fnmode - Mode of top-row keys
        #     0 - disabled
        #     1 - normally media keys, switchable to function keys by holding Fn key (=auto on Apple keyboards)
        #     2 - normally function keys, switchable to media keys by holding Fn key (=auto on non-Apple keyboards)
        #     3 - auto (Default)
        type = lib.types.nullOr lib.types.enum ["disabled" "media" "function" "auto"];
        default = null;
        description = "Set the mode of the top-row keys on Apple keyboards";
      };
    };
  };

  config = lib.mkIf isEnabled {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 20;
          consoleMode = pkgs.lib.mkDefault "auto";
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      kernelPackages = pkgs.lib.mkDefault pkgs.linuxPackages_latest;
      kernelParams = [];
      # ++ (emptyOrMap cfg.kernelParams.appleShowNotch (value: "apple_dcp.show_notch=${mapAttr boolToIntMap value}"))
      # ++ (emptyOrMap cfg.kernelParams.appleFnMode (value: "hid_apple.fnmode=${mapAttr fnModeMap value}"));
    };
  };
}
