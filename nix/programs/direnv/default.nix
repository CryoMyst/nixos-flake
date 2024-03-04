{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.direnv;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.direnv = {
    enable = lib.mkEnableOption "Enable direnv configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        programs = {
          direnv = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            nix-direnv = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
