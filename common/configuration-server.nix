# man 5 configuration.nix
# nixos-help
{ config, pkgs, lib, hostname, username, internalIPv4, externalIPv4, localIPv6, globalIPv6, ... }:
{
  imports =
    [
      ./configuration-common.nix
      ./environment.nix
      ./hardware.nix
      ./networking.nix
      ./programs.nix
      ./security.nix
      ./services.nix
      ./systemd.nix
      ./users/ember/home.nix
    ];
}