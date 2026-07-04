pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
in
with pkgs; [
    aha # for formatting the output of the firmware section of the Info Centre
    android-tools
    bluez-alsa
    bluez-tools
    btop
    cdrkit
    cdrtools
    clinfo
    cmatrix
    comma
    egl-wayland
    enhanced-ctorrent
    exfat
    exfatprogs
    file
    f3 # doesn't compile due to libudev.h missing
    glances
    gptfdisk
    hdparm
    hidapi
    # htop # dealt with
    inetutils
    jmtpfs
    jnettop
    kexec-tools
    # linux_logo # *** buffer overflow detected ***: terminated
    lm_sensors
    lshw
    lsof
    mesa-demos
    mono
    # multibootusb # broken GUI, also broken
    ncdu
    networkmanager # possibly unneeded
    nix-index
    nixfmt
    ntfs3g
    obexfs
    obexftp
    ooniprobe-cli
    # opencorsairlink
    p7zip
    pciutils
    power-profiles-daemon
    powertop # the actual package not the auto tuner
    pv
    rpiboot
    sixpair
    smartmontools
    socat
    supergfxctl
    testdisk
    u3-tool
    udftools
    unrar
    unzip
    usbutils
    #  - Ventoy uses binary blobs which can't be trusted to be free of malware or compliant to their licenses.
    # https://github.com/NixOS/nixpkgs/issues/404663
    # See the following Issues for context:
    # https://github.com/ventoy/Ventoy/issues/2795
    # https://github.com/ventoy/Ventoy/issues/3224
    # ventoy
    vulkan-tools
    wayland-utils
    wget
    wirelesstools
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    i7z
] else [
   # pkgs-x86_64.i7z
])
