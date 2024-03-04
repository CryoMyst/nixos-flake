{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.qt;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.qt = {
    enable = lib.mkEnableOption "Enable qt themes.";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            adwaita-qt
            adwaita-qt6
            qt5.qtwayland
            qt6.qtwayland
          ];
        };
        qt = {
          enable = true;
          platformTheme = "gnome";
          style.name = "adwaita-dark";
        };
      };
    };
  };
}
