{
  lib,
  pkgs,
  home-manager,
  nix-sops,
  config,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    ./vfio.nix
  ];

  cryo = {
    enable = true;
    username = "cryomyst";
    hostname = "cryo-desktop";
    stateVersion = "23.11";
    setups = {
      sway.enable = true;
    };
    features = {
      graphics.gpuTypes = ["amd"];
      sops = {
        enable = true;
      };
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/keys/nix-sops/key.txt";
    secrets = {
      cryomyst-password = {
        neededForUsers = true;
      };
    };
  };
  users.users."cryomyst".hashedPasswordFile = config.sops.secrets.cryomyst-password.path;

  fileSystems."/mnt/nvme2" = {
    device = "/dev/disk/by-uuid/d69b4e16-344f-4146-b55f-c4bc1518ea38";
    fsType = "ext4";
  };

  boot.kernelParams = [
    "zswap.enabled=1"
    "amd_pstate=active"
    "amd_iommu=on"
    "mitigations=off"
    "panic=1"
    "nowatchdog"
    "nmi_watchdog=0"
    "quiet"
    "rd.systemd.show_status=auto"
    "rd.udev.log_priority=3"
  ];

  home-manager.users = {
    cryomyst = {
      home = {
        packages = with pkgs;
          [
            obs-studio
          ]
          ++ [
          ];
      };
      wayland = {
        windowManager = {
          sway = {
            config = rec {
              startup = [
                {
                  command = ''
                    xrandr --verbose --output "HDMI-A-1" --primary
                  '';
                  always = true;
                }
              ];

              keybindings = let
                # Just redefine here for now
                modifier = "Mod4";
              in
                pkgs.lib.mkOptionDefault {
                  # 10th workspace for 2nd display
                  "${modifier}+0" = "workspace number 10";
                  "${modifier}+Shift+0" = "move container to workspace number 10";
                };

              output = {
                "HDMI-A-1" = {
                  mode = "3840x2160@120.000Hz";
                  pos = "1080,0";
                };
                "DP-1" = {
                  mode = "1920x1080@60.000Hz";
                  pos = "0,0";
                  transform = "270";
                };
              };

              workspaceOutputAssign = [
                {
                  output = "HDMI-A-1";
                  workspace = "1";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "2";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "3";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "4";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "5";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "6";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "7";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "8";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "9";
                }
                {
                  output = "DP-1";
                  workspace = "10";
                }
              ];
            };
          };
        };
      };
    };
  };
}
