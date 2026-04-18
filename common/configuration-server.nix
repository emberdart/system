# man 5 configuration.nix
# nixos-help
{ config, pkgs, lib, hostName, internalIPv4, externalIPv4, localIPv6, globalIPv6, fqdn, ... }:
let
  rootDir = "/home/dwd/code/mine/nix/system";
  hostDir = "${rootDir}/${hostName}";
  privateDir = "${hostDir}/private";
in
{
  imports =
    [
      ./configuration-common.nix
    ];

  environment = import ./environment.nix { inherit pkgs;  inherit config; inherit lib; systemPackages = import ./packages/console/packages.nix pkgs; };
  hardware = import ./hardware.nix { inherit pkgs; isDesktop = false; };
  networking = import ./networking.nix { inherit pkgs; inherit lib; inherit hostName; isDesktop = false; };
  programs = import ./programs.nix { inherit pkgs; isDesktop = false; };
  security = import ./security.nix { inherit pkgs; inherit lib; isDesktop = false; inherit hostName; inherit privateDir; };
  services = import ./services.nix { inherit pkgs; inherit hostName; inherit hostDir; inherit privateDir; inherit internalIPv4; inherit externalIPv4; inherit localIPv6; inherit globalIPv6; inherit fqdn; isDesktop = false; };
  systemd = import ./systemd.nix { inherit lib; inherit pkgs; inherit privateDir; isDesktop = false; };
  
  home-manager.users.dwd = import ./users/dwd/home.nix { inherit pkgs; isDesktop = false; };
}