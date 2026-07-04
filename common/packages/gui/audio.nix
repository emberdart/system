pkgs:
with pkgs;
[
    a2jmidid # CLI
    AMB-plugins
    ardour
    audacity # rapidjson problem
    autotalent
    # baudline # download link is down
    carla # also a plugin host # can't build python3.12-pyliblo # cython-0.29.37.1 not supported for interpreter python3.13
    caps
    clementine
    crosspipe
    csa
    faust2ladspa
    # fluida-lv2
    fluidsynth
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # helvum # like qjackctl but lines and also what gladish was  # unmaintained and vulnerable dep; replacement suggestion is crosspipe
    hydrogen
    # ingen # build failed with raul-unstable
    # jack_rack # won't build
    # kapitonov-plugins-pack # loads of weird errors
    mt32emu-qt
    # nova-filters # includes jack-rack?
    pavucontrol
    picard
    # qarecord # TODO request
    qjackctl # the other one?
    qsynth
    rosegarden # dssi fails to build
    sfizz
    sfizz-ui
    soundfont-arachno
    soundfont-fluid
    yoshimi
    x42-gmsynth
    zam-plugins
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    bristol # no desktop icon # can't compile
    plugin-torture # broken on aarch64
    polyphone # no desktop icon # broken on aarch64
    # tuxguitar # swt: os.c:1759:9: error: 'gdk_pixbuf_loader_get_animation' is deprecated [-Werror=deprecated-declarations] # no desktop icon # REALLY broken on aarch64
    x42-gmsynth # broken on aarch64
] else [
])
