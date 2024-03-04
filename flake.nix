{
  description = "CryoMyst NixOS Configuration";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems-list = import ./systems/systems.nix;
  in {
    nixosConfigurations = builtins.listToAttrs (
      map (
        value: {
          name = value.hostname;
          value = nixpkgs.lib.nixosSystem rec {
            system = value.system-type;
            specialArgs =
              inputs
              // {
                nixpkgs-stable = nixpkgs.lib.callPackage inputs.nixpkgs-stable {};
                nixpkgs-unstable = nixpkgs.lib.callPackage inputs.nixpkgs-unstable {};
                nixpkgs-master = nixpkgs.lib.callPackage inputs.nixpkgs-master {};
              };
            modules = [
              ./systems/${value.hostname}/configuration.nix
              ./nix
            ];
          };
        }
      )
      systems-list
    );
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = "github:nix-community/nur";
    devenv.url = "github:cachix/devenv";

    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
