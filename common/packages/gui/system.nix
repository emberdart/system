pkgs:
with pkgs; [
    alacritty
    cascadia-code
    # clamtk
    cryptsetup
    #etcher
    ghostty
    gparted
    iosevka
    kitty
    lexend
    linux-exploit-suggester
    linux-wallpaperengine
    nerd-fonts.space-mono
    # nerd-fonts.STUFFGOESHERE
    rpi-imager
    # stacer # removed since it was abandoned upstream and  relied on vulnerable software
    #unetbootin
    wev
    #winusb
    #woeusb # -ng
    # wsysmon # sigsegv
    #xcruiser # no desktop icon
    #xorg.xev
    systembus-notify # make it autostart?
    testdisk-qt
    timeshift
    turbovnc # from tightvnc
    unifont
    unifont-csur
    unifont_upper
    zap
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    # xorg.xf86videointel
] else [
])
