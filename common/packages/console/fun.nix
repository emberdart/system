pkgs:
with pkgs; [
    ddate
    fastfetch
    fortune
    genact
    # haxor-news # ERROR Backend 'setuptools.build_meta:__legacy__' is not available. - python3.13-click-7.1.2.drv' failed with exit code 1
    hollywood
    # hyfetch # doesn't build properly?
    lavat
    # neofetch # use neowofetch from hyfetch
    nitch
    nms
    screenfetch
]
