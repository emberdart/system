pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
in
with pkgs; [
    clementine
    # clementineUnfree # needs building?
    #ffmpeg-full #insecure for now
    kaffeine
    vlc
    gnome-network-displays
    # guvcview # FF_PROFILE consts undeclared - maybe they should update to AV
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    # mplayer # no longer builds
    spotify
    # spotifywm # spotifywm.cpp:12:10: fatal error: xcb/xproto.h: No such file or directory
] else [
   # pkgs-x86_64.mplayer
   # pkgs-x86_64.spotify
   # pkgs-x86_64.spotifywm
])
