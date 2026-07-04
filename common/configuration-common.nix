# man 5 configuration.nix
# nixos-help
{ config, pkgs, lib, hostname, homeDirectory, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
  };
  lanzaboote = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/lanzaboote/archive/refs/tags/v1.0.0.tar.gz";
  }) {};

in {
  _module = {
    args = rec {
      rootDir = "${homeDirectory}/code/mine/nix/system";
      hostDir = "${rootDir}/${hostname}";
      privateDir = "${hostDir}/private";
    };
  };
  imports =
    [
      "${home-manager}/nixos"
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
      lanzaboote.nixosModules.lanzaboote
      ./boot.nix
      ./console.nix
      ./i18n.nix
      ./nix.nix
      ./nixpkgs.nix
      ./time.nix
      ./users.nix
      ./virtualisation.nix
    ];

  home-manager.backupFileExtension = ".bak";

  # todo move

  # powerManagement.powertop.enable = true; # no because the mouse dies a lot otherwise
}
