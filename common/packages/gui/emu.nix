pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
    # pkgs-i686-windows = import <nixos> {
    #     system = "i686-windows";
    #     config = {
    #         allowUnfree = true;
    #     };
    # };
    winapps =
        (import (builtins.fetchTarball "https://github.com/winapps-org/winapps/archive/main.tar.gz"))
        .packages."${pkgs.system}";
in
with pkgs; [
    # chiaki-ng # Qt::GuiPrivate issue
    # desmume # no longer builds
    dosbox
    # duckstation # use appimage instead
    # epsxe # insecure openssl
    higan
    mednafen
    # melonDS # /build/source/src/frontend/qt_sdl/Screen.cpp:28:10: fatal error: qpa/qplatformnativeinterface.h: No such file or directory
    mymcplus # yes no desktop entry
    # pcsxr # depends on insecure ffmpeg
    ppsspp
    #protontricks8
    # proton-caller # removed; unmaintained
    # rpcs3 # fails to build
    ruffle
    virt-viewer
    # waydroid # cython-0.29.37.1 not supported for interpreter python3.13
    # winePackages.fonts
    # master.winePackages.staging
    # winetricks # depend on correct version
    #(winetricks.override {
    #    wine = wineWow64Packages.staging;
    #})
    wiiload
    wiimms-iso-tools
    wiiuse
    vkd3d-proton
    winapps.winapps
    winapps.winapps-launcher
    # winboat # ⨯ Could not detect abi for version 41.2.0 and runtime electron.  Updating "node-abi" might help solve this issue if it is a new release of electron  failedTask=build stackTrace=Error: Could not detect abi for version 41.2.0 and runtime electron.  Updating "node-abi" might help solve this issue if it is a new release of electron
    winetricks
    # master.yuzu
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    # citra # broken on aarch64
    # pcsx2 # keeps recompiling # /build/source/pcsx2-qt/DisplayWidget.cpp:29:10: fatal error: 'qpa/qplatformnativeinterface.h' file not found
    pcsx2
    # pkgs-i686-windows.wine-discord-ipc-bridge
    # retroarchFull # TODO: get rid of libretro-parallel-n64-code - that's the one that's broken on aarch64 # takes ages to compile even on a good machine, why is it even bothering
    wineWow64Packages.fonts
    # master.wineWow64Packages.staging # takes forever to compile
    wineWow64Packages.staging # waylandFull
] else [
    # pkgs-x86_64.citra # broken on aarch64
    # pkgs-x86_64.pcsx2 # keeps recompiling
    # pkgs-x86_64.retroarchFull # TODO: get rid of libretro-parallel-n64-code - that's the one that's broken on aarch64
    # pkgs-x86_64.wineWow64Packages.fonts
    # master.wineWow64Packages.staging # takes forever to compile
    # pkgs-x86_64.wineWow64Packages.staging
])

