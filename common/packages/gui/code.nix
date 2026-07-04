pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
in
with pkgs; [
    cool-retro-term
    # android-tools # build failure at fipsmodule
    circup
    diylc
    gnucap
    # horizon-eda
    kdePackages.kate
    # librepcb # lots of missing packages
    logisim
    logisim-evolution
    neovim-qt
    ngspice
    pcb
    # python314Packages.cirq-web # presumably dependent on core
    # python314Packages.cirq-rigetti # failing tests, no binary???
    # python314Packages.cirq-pasqal # presumably dependent on core
    # python314Packages.cirq-ionq # build failure
    # python314Packages.cirq-google # build failure
    # python314Packages.cirq-core # fails to build
    # python314Packages.cirq-aqto # missing
    # python314Packages.cirq # depends on rigetti
    # qucs
    # stlink # won't build
    # tkgate # won't build
    vscodium # insiders?
    # x11docker
    # xcircuit # no longer builds
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    # androidStudioPackages.canary # dependent on android-tools?
    # xyce # broken on aarch64
    # xyce-parallel
] else [
    ## pkgs-x86_64.androidStudioPackages.canary ???
    ## pkgs-x86_64.xyce # takes an age to build
    ## pkgs-x86_64.xyce-parallel # presumably another age to build
])
