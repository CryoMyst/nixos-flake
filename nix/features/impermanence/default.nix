{
  lib,
  pkgs,
  config,
  home-manager,
  impermanence,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.features.impermanence;
  isEnabled = cfg.enable && cryo.enable;
in {
  imports = [
    impermanence.nixosModules.impermanence
  ];

  options.cryo.features.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence support";
    enableRoot = lib.mkEnableOption "Enable impermanence for root";
    enableHome = lib.mkEnableOption "Enable impermanence for home";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      imports = [
        impermanence.nixosModules.home-manager.impermanence
      ];
    };
  };
}
