{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.gtk;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.gtk = {
    enable = lib.mkEnableOption "Enable gtk themes.";
  };

  config = lib.mkIf isEnabled {
    environment = {
      sessionVariables = {
        GTK_THEME = "Adwaita:dark";
      };
    };

    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            gnome.adwaita-icon-theme
          ];
        };

        gtk = {
          enable = true;
          iconTheme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.adwaita-icon-theme;
          };
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.adwaita-icon-theme;
          };
        };
      };
    };
  };
}
