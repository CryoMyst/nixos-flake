{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.lutris;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.lutris = {
    enable = lib.mkEnableOption "Enable lutris configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            (lutris.override {
              extraPkgs = pkgs: [
                winetricks
                wineWowPackages.staging
                libnghttp2
                jansson
              ];
            })
          ];
        };
      };
    };
  };
}
