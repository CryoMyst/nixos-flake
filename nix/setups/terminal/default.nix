{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.setups.terminal;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.setups.terminal = {
    enable = lib.mkEnableOption "Enable terminal setup";
  };

  config = lib.mkIf isEnabled {
    cryo = {
      programs = {
        direnv.enable = true;
        tmux.enable = true;
        nvim.enable = true;
        zsh.enable = true;
      };
    };

    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            git
            htop
            btop
            unzip
            p7zip
            hdparm
            wget
            jq
            lazygit
            lazydocker
            zoxide
            pciutils
            valgrind
            distrobox
            screen
            man-pages
            man-pages-posix
          ];
        };
      };
    };
    documentation.dev.enable = true;
  };
}
