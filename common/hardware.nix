{ pkgs, isDesktop, ...}:
{
  hardware = {
    cpu.intel.updateMicrocode = builtins.currentSystem == "x86_64-linux";

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
    };

    hackrf.enable = true;

    graphics.enable = true;

    usb-modeswitch.enable = true;

    # sane = if isDesktop then {
    #   enable = true;
    #   extraBackends = with pkgs; [
    #     hplipWithPlugin
    #   ];
    # } else {};
  };
}
