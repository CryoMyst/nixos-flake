{
  pkgs,
  lib,
  nixpkgs,
  nixpkgs-stable,
  nixpkgs-unstable,
  nixpkgs-master,
  ...
}: let
in [
  (self: super: {
    # Expose these for the system to use.
    inherit
      nixpkgs
      nixpkgs-stable
      nixpkgs-unstable
      nixpkgs-master
      ;
  })
  #   (import ./overlay-definition.nix)
]
