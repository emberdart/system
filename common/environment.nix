{ pkgs, lib, config, ... }:
{
  imports = [
    ./packages/packages.nix
  ];
  environment = {
    pathsToLink = [
      "/share/nix-direnv"
      "/share/applications"
    ];

    # Workaround for NixOS issue https://github.com/NixOS/nixpkgs/issues/110468
    sessionVariables.LD_LIBRARY_PATH = lib.mkForce "${config.services.pipewire.package.jack}/lib";

    # use services.ax25 here

    # etc = {
    #   "ax25/soundmodem.conf" = {
    #     enable = false;
    #     text = ''
    #     '';
    #   };
  # 
    #   "ax25/axports" = {
    #     enable = false;
    #     text = ''
    #     '';
    #   };
    # };
  };
}