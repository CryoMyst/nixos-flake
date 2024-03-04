{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.graphics;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.features.graphics = {
    enable = lib.mkEnableOption "Enable graphics support";
    gpuTypes = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["nvidia" "amd" "asahi"]);
      default = [];
      description = "List of GPUs to enable support for";
    };
  };

  config = lib.mkIf isEnabled {
    assertions = [
      {
        assertion = (builtins.length cfg.gpuTypes) > 0;
        message = ''
          At least one GPU type must be enabled when graphics support is enabled.
          Please set `cryo.features.graphics.gpuTypes` to a non-empty list of valid GPU types (nvidia, amd, asahi).
        '';
      }
    ];

    boot.initrd.kernelModules =
      []
      ++ (lib.optionals (builtins.elem "nvidia" cfg.gpuTypes) ["nvidia"])
      ++ (lib.optionals (builtins.elem "amd" cfg.gpuTypes) ["amdgpu"]);

    services.xserver.videoDrivers =
      []
      ++ (lib.optionals (builtins.elem "nvidia" cfg.gpuTypes) ["nvidia"])
      ++ (lib.optionals (builtins.elem "amd" cfg.gpuTypes) ["amdgpu"]);

    hardware = lib.mkMerge [
      (
        if builtins.elem "nvidia" cfg.gpuTypes
        then {
          opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
          };
          nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.beta;
          };
        }
        else {}
      )
      (
        if builtins.elem "amd" cfg.gpuTypes
        then {
          opengl = {
            enable = true;
            extraPackages = with pkgs; [rocm-opencl-icd rocm-opencl-runtime amdvlk mesa.drivers];
            extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
            driSupport = true;
            driSupport32Bit = true;
          };
        }
        else {}
      )
      (
        if builtins.elem "asahi" cfg.gpuTypes
        then {
          asahi = {
            addEdgeKernelConfig = true;
            useExperimentalGPUDriver = true;
            #   Mode to use to install the experimental GPU driver into the system.

            #   driver: install only as a driver, do not replace system Mesa.
            #     Causes issues with certain programs like Plasma Wayland.

            #   replace (default): use replaceRuntimeDependencies to replace system Mesa with Asahi Mesa.
            #     Does not work in pure evaluation context (i.e. in flakes by default).

            #   overlay: overlay system Mesa with Asahi Mesa
            #     Requires rebuilding the world.
            experimentalGPUInstallMode = "overlay";
            withRust = true;
          };
          opengl.enable = true;
        }
        else {}
      )
    ];
  };
}
