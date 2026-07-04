# man 5 configuration.nix
# nixos-help
{ config, pkgs, lib, hostname, domain, username, homeDirectory, internalIPv4, externalIPv4, localIPv6, globalIPv6, ... }:
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
  
  # Don't do this for servers!
  #specialisation.testing.configuration = {
  #  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing; # linuxKernel.kernels.linux_testing
  #};

  # specialisation.NVIDIA_Open.configuration = {
  #   hardware.nvidia.open = lib.mkForce true;
  # };

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
