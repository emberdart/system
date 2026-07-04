# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let 
    impermanence = builtins.fetchTarball {
      url =
        "https://github.com/nix-community/impermanence/archive/master.tar.gz";
    };
in
{
    _module = {
        args = {
            internalIPv4 = "192.168.0.12";
            externalIPv4 = null;
            localIPv6 = "fe80::5f45:a07:ee5e:112d";
            globalIPv6 = null; # boooo
            hostname = "scorpii";
            domain = "emberella.co.uk";
            username = "ember";
            home = "/home/ember";
            # wifiNetwork
            # wifiPassword
            # bssid24
            # bssid5
        };
    };
    imports = [
        "${impermanence}/nixos.nix"
        ./hardware-configuration.nix
        ../common/configuration-desktop.nix
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
}
