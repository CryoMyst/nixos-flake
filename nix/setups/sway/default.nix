{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.setups.sway;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.setups.sway = {
    enable = lib.mkEnableOption "Enable sway setup";
  };

  config = lib.mkIf isEnabled {
    cryo = {
      programs = {
        alacritty.enable = true;
        gtk.enable = true;
        i3status.enable = true;
        jetbrains.enable = true;
        lutris.enable = true;
        qt.enable = true;
        sway.enable = true;
        swaylock.enable = true;
        wayvnc.enable = true;
        wine.enable = true;
      };
      features = {
        boot.enable = true;
        graphics.enable = true;
        locale.enable = true;
        network.enable = true;
        sound.enable = true;
        fonts.enable = true;
      };
      services = {
        docker.enable = true;
        ssh.enable = true;
        swayidle.enable = true;
        xserver.enable = true;
      };
      setups = {
        social.enable = true;
        terminal.enable = true;
      };
      personal = {
        ssh.cryomyst = true;
      };
    };

    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            firefox
            obs-studio
            obsidian
            remmina
            freerdp
            gnome.file-roller
            gitkraken
            vscode
          ];
        };
      };
    };

    security = {
      pam = {
        services = {
          sddm.enableGnomeKeyring = true;
        };
      };
    };

    programs = {
      dconf.enable = true;
      noisetorch.enable = true;
      zsh.enable = true;
      nix-ld.enable = true;
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
      };
    };

    services = {
      printing.enable = true;
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      devmon.enable = true;
      tumbler.enable = true;

      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.sway}/bin/sway";
            user = "${cryo.username}";
          };
          default_session = initial_session;
        };
      };
    };
  };
}
