pkgs:
with pkgs; [
    # avidemux # fails to build
    # cinelerra # keeps compiling # too big for now
    flowblade
    kdePackages.kdenlive
    lightworks
    simplescreenrecorder
    # obs-studio
    # olive-editor # /nix/store/zp6r9bxds1hldvkx1vbrk0d1ady17zhh-qtbase-6.10.1/include/QtCore/qstring.h:364:5: error: no type named 'type' in 'struct std::enable_if<false, QString>'
    # openshot-qt # no qtwebengine
    # pitivi # requires triton-llvm which takes 10 years and 100 GB of RAM to build
    # shotcut # won't build because of jack1
]