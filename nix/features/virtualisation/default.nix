{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.virtualisation;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.virtualisation = {
    enable = lib.mkEnableOption "Enable virtualisation support";
    hostCpu = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["intel" "amd" "apple"]);
      default = null;
      description = "The CPU type of the host";
    };
    vfioDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "A list of PCI devices bind to the vfio-pci driver";
    };
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        home = {
          packages = with pkgs; [
            virt-manager
          ];
        };
      };
    };

    # Not sure if this is needed
    hardware.opengl.enable = true;

    boot = let
      vfioDevices-kernel-param = "vfio-pci.ids=" + lib.concatStringsSep "," cfg.vfioDevices;
    in {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams =
        if cfg.hostCpu == "intel"
        then ["intel_iommu=on" vfioDevices-kernel-param]
        else if cfg.hostCpu == "amd"
        then ["amd_iommu=on" vfioDevices-kernel-param]
        else
          # Not sure if any flags are required for M1 or if PCIE
          [];
    };

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
        };
      };
    };

    programs.dconf.enable = true;
    services.spice-vdagentd.enable = true;

    users.users = {
      ${cryo.username} = {
        extraGroups = [
          "libvirtd"
        ];
      };
    };
  };
}
