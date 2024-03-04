# `nix` directory
This directory contains the nix module for the flake.
This module is highly opinionated for myself.

## `core`
The `core` contains configurations for nix itself and home-manager.

Examples: caching, gc, allowUnfree, etc.

## `features`
High level features that can be enabled or disabled.

Examples: cpu, ram, sound, virtualization, etc.

## `overlays`
Overlays to apply to nixpkgs which might contain fixes or package redirections to other channels.

Examples: `azure-cli` was broken on `unstable` so it was redirected to `stable`

## `packages`
Custom packages that are not in nixpkgs. These need to be imported to be used.

## `personal`
Personal configurations that cannot be shared. These usually require local network access or sops secrets to use.

Examples: network shares, vpns, etc.

## `programs`
Opinionated program configurations.

Examples: `neovim`, `firefox`, `alacritty`, etc.

## `services`
Opinionated service configurations.

Examples: `docker`, `ssh`, `xserver`

## `setups`
Very high level setups that are comprised of all the above.

Examples: `terminal`, `social`, `workstation`