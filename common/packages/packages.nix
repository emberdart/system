{ pkgs, ... }:
# Any defaults/must-haves go here
{
    environment.systemPackages = import ./console/packages.nix pkgs
        ++ import ./gui/packages.nix pkgs;
}