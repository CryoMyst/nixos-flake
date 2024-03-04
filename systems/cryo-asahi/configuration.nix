{
  lib,
  pkgs,
  nixpkgs,
  nixos-apple-silicon,
  ...
}: let
  openlens-arm64 = (import ./../../nix/packages/openlens-arm64) {
    inherit pkgs;
    inherit lib;
  };
in {
  imports = [
    ./hardware-configuration.nix
    # Hack to workaround not being able to conditional imports in modules.
    # This should be moved into the flake module when the following issue is resolved:
    # https://github.com/tpwrules/nixos-apple-silicon/issues/168
    nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  cryo = {
    enable = true;
    username = "cryomyst";
    hostname = "cryo-asahi";

    setups = {
    };

    services = {
      strongswan = {
        enable = true;
        externalJson = "/etc/nixos/secrets/vpns/work_vpns.json";
      };
    };

    features = {
      sound.enable = lib.mkForce false; # Override by Asahi sound
      virtualisation.enable = lib.mkForce false;
      boot = {
        kernelParams = {
          appleShowNotch = false;
          appleFnMode = "media";
        };
      };
    };
  };

  boot = {
    kernelParams = [
      "apple_dcp.show_notch=0"
      "hid_apple.fnmode=1"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024;
    }
  ];

  home-manager.users = {
    cryomyst = {
      home = {
        packages = with pkgs;
          [
            azure-cli
            brightnessctl
          ]
          ++ [
            openlens-arm64
          ];
      };

      wayland = {
        windowManager = {
          sway = {
            config = rec {
              keybindings = let
                modifier = "Mod4";
              in
                pkgs.lib.mkOptionDefault {
                  "${modifier}+Shift+i" = "exec swaymsg input type:touchpad events toggle";
                  "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
                  "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
                  "Shift+XF86MonBrightnessUp" = "exec brightnessctl set +10% -d kbd_backlight";
                  "Shift+XF86MonBrightnessDown" = "exec brightnessctl set 10%- -d kbd_backlight";

                  # Screenshot
                  "${modifier}+Shift+p" = ''exec grim -g "$(slurp)" - | wl-copy'';
                };

              output = {
                "HDMI-A-1" = {
                  mode = "3840x2160@60.000Hz";
                  pos = "0,0";
                };
                "eDP-1" = {
                  mode = "3456x2160@60.000Hz";
                  scale = "1.2";
                  pos = "3840,0";
                };
              };

              input = {
                "*" = {
                  natural_scroll = "disabled";
                  accel_profile = "flat";
                  pointer_accel = "0.5";
                };
              };
            };
          };
        };
      };

      xdg.desktopEntries = {
        "Firefox - CryoMyst" = {
          name = "Firefox CryoMyst";
          exec = "firefox -p CryoMyst";
          terminal = false;
        };
        "Firefox - Icon" = {
          name = "Firefox Icon";
          exec = "firefox -p Icon";
          terminal = false;
        };
      };

      programs = {
        i3status = {
          modules = {
            "battery 1" = {
              position = 4;
              settings = {
                path = "/sys/class/power_supply/macsmc-battery/uevent";
                format = "%percentage (%remaining)";
              };
            };
          };
        };
      };
    };
  };

  programs.nm-applet.enable = true;
  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      setupAsahiSound = true;
    };
  };

  services = {
    upower.enable = true;
    fstrim.enable = true;
    timesyncd.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  zramSwap.enable = true;
}
