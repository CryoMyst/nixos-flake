let
  gpuIds = [
    "1002:73ff" # Graphics
    "1002:ab28" # Audio
  ];
in
  {
    pkgs,
    lib,
    config,
    home-manager,
    ...
  }: {
    cryo.features.virtualisation = {
      enable = true;
      hostCpu = "amd";
      vfioDevices = gpuIds;
    };
    cryo.programs.looking-glass.enable = true;
  }
