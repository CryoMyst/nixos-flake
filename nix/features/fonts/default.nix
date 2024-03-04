{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.fonts;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.fonts = {
    enable = lib.mkEnableOption "Enable additional fonts";
  };

  config = lib.mkIf isEnabled {
    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        ubuntu_font_family
        source-code-pro
        proggyfonts
        powerline-fonts
        noto-fonts-emoji
        noto-fonts-cjk
        noto-fonts
        nerdfonts
        mplus-outline-fonts.githubRelease
        liberation_ttf
        kanji-stroke-order-font
        jetbrains-mono
        ipafont
        font-awesome
        emojione
        dina-font
        corefonts
      ];
    };
  };
}
