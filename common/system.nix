{ hostname, ... }:
{
    system = {
        autoUpgrade = {
            enable = true;
            persistent = true; 
            dates = "hourly";
            allowReboot = false; # okay this is getting annoying, disabled until NixOS supports kexec/ksplice/etc
            # at least do it when I'm not copying things for the 4th time!!!
            rebootWindow = {
                lower = "19:00";
                upper = "07:00";
            };
            flags = [
                "-I"
                "nixos-config=${homeDirectory}/code/mine/nix/system/${hostname}/configuration.nix"
            ];
        };
    };
}
