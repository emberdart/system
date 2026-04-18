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

  environment = import ./environment.nix { inherit pkgs;  inherit config; inherit lib; systemPackages = import ./packages/packages.nix pkgs;};
  hardware = import ./hardware.nix { inherit pkgs; isDesktop = true; };
  networking = import ./networking.nix { inherit pkgs; inherit lib; inherit hostName; isDesktop = true; };
  programs = import ./programs.nix { inherit pkgs; isDesktop = true; };
  security = import ./security.nix { inherit pkgs; inherit lib; isDesktop = true; inherit hostName; inherit privateDir; };
  services = import ./services.nix { inherit pkgs; inherit hostName; inherit hostDir; inherit privateDir; inherit internalIPv4; inherit externalIPv4; inherit localIPv6; inherit globalIPv6; inherit fqdn; isDesktop = true; };
  systemd = import ./systemd.nix { inherit lib; inherit pkgs; inherit privateDir; isDesktop = true; };
  
  home-manager.users.dwd = import ./users/dwd/home.nix { inherit pkgs; isDesktop = true; };

  # Don't do this for servers!
  #specialisation.testing.configuration = {
  #  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing; # linuxKernel.kernels.linux_testing
  #};

  # specialisation.musl.configuration = {
  #   system = "x86_64-linux-musl";
  # };

  # specialisation.server-mode.configuration = {
  #   environment.systemPackages = import ./packages/console/packages.nix pkgs;
  #   services.xserver.enable = lib.mkForce false;
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  # };
# 
  # specialisation.cinnamon.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  #   services.xserver.desktopManager.cinnamon.enable = true;
  #   services.cinnamon.apps.enable = true;
  # };
# 
  # specialisation.gnome.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  # };
# 
  # specialisation.surf.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  #   services.xserver.desktopManager.surf-display.enable = true;
  #   services.xserver.desktopManager.surf-display.defaultWwwUri = "https://jolharg.com";
  # };
# 
  # specialisation.retroarch.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  #   services.xserver.desktopManager.retroarch.enable = true;
  # };
# 
  # specialisation.pantheon.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  #   services.xserver.desktopManager.pantheon.enable = true;
  # };
# 
  # specialisation.enlightenment.configuration = {
  #   services.xserver.displayManager.sddm.enable = lib.mkForce false;
  #   services.xserver.displayManager.lightdm.enable = true;
  #   services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  #   services.xserver.desktopManager.enlightenment.enable = true;
  # };
}
