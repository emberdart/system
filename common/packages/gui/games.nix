pkgs:
let pkgs-x86_64 = import <nixos> {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };
    pkgs-doomsday = import (builtins.fetchTarball "https://github.com/pluiedev/nixpkgs/archive/refs/heads/init/doomsday-engine.tar.gz") {};
in
with pkgs; [
    airshipper
    # alephone # too small fov
    # # alephone-apotheosis-x - hash mismatch - # Unfortunately, we cannot download file Apotheosis_X_1.1.zip automatically
    #     # Please go to https://www.moddb.com/mods/apotheosis-x/downloads to download it yourself, and add it to the Nix store
    #     # using either
    #     #   nix-store --add-fixed sha256 Apotheosis_X_1.1.zip
    #     # or
    #     #   nix-prefetch-url --type sha256 file:///path/to/Apotheosis_X_1.1.zip
    # alephone-durandal
    # alephone-eternal
    # alephone-evil
    # alephone-infinity
    # alephone-marathon
    # alephone-pathways-into-darkness
    # alephone-pheonix
    # alephone-red
    # # alephone-rubicon-x # python3.13-click-7.1.2.drv' failed with exit code 1 -  ERROR Backend 'setuptools.build_meta:__legacy__' is not available.
    # alephone-yuge
    # alienarena # no desktop icon # segfaults
    # haskellPackages.armada # marked broken
    # armagetronad # no desktop icon # failed with exit code 141
    # barrage # arcadey
    # bloodspilot-client # dies
    # bloodspilot-server # dies
    # brutalmaze # python3.13-palace-0.2.5 - cython-0.29.37.1 not supported for interpreter python3.13
    chromium-bsu
    crossfire-arch
    crossfire-client
    crossfire-gridarta
    crossfire-jxclient
    crossfire-maps
    crossfire-server
    # crrcsim # doesn't launch
    dolphin-emu
    pkgs-doomsday.doomsday-engine
    # haskellPackages.edge # cmdtheline is broken
    # endgame-singularity # nahh
    endless-sky
    # extremetuxracer
    # exult # requires extra game data
    # fceux-qt6 # no longer builds
    flare # interesting top down rpg with lowish res
    # flightgear # big and takes a while to compile
    flight-of-the-amazon-queen
    # fltrator # all you do is die
    # freedroid # meh
    # freedroidrpg # meh
    # freeorion # /build/source/server/ServerNetworking.cpp:In member function 'void PlayerConnection::SendMessage(const Message&)': 236: error: 'class boost::asio::io_context' has no member named 'post'
    # frozen-bubble
    # galaxis # tui it's just battleships
    # gamehub # libsoup 2 is too vulnerable
    # garden-of-coloured-lights # much muchly
    # golly # now broken?
    hhexen
    ioquake3
    # katawa-shoujo-re-engineered # renpy: future-1.0.0 not supported for interpreter python3.13
    krabby
    # lbreakout2
    # legends-of-equestria # build takes too long without saying anything much.... :(
    liberal-crime-squad
    # liberation-circuit # no desktop icon # wat
    lincity
    # ltris
    # maelstrom # just asteroids
    # manaplus # build
        # utils/dumplibs.cpp: In function 'void dumpLibs()':
        # utils/dumplibs.cpp:143:38: error: '__xmlParserVersion' was not declared in this scope; did you mean 'xmlParserVersion'?
        # 143 |     const char * const *xmlVersion = __xmlParserVersion();
        # builder for '/nix/store/01b4z7gas8acp7shn5ilwsz6gkbsdr4k-manaplus-2.1.3.17-unstable-2024-08-15.drv' failed with exit code 2
    # mars # nonsense
    # megaglest # more like meh-a-glest
    # mgba
    # minigalaxy # GOG client
    # mupen64plus # no desktop icon
    # naev # ay that's aight # ERROR: Unhandled python exception
    nethack-qt # no desktop icon
    newtonwars
    nexuiz # no desktop icon # BIG
    # openarena # no desktop icon # BIG # fails to build - https://github.com/OpenArena/engine/issues/94 https://github.com/NixOS/nixpkgs/issues/370954
    opendungeons # wtf
    openmw
    outfly # no desktop icon # oooooh
    # padman?
    pokemon-cursor
    # pokete # meh small
    # pinball # oh no
    # pioneer # mehh
    # planetary_annihilation # This file has to be downloaded manually via nix-prefetch-url. TODO find it
    # powermanga # silly
    protonup-qt # for luxtorpeda
    # quakespasm # no desktop icon
    # qwbfsmanager # TODO REQUEST
    # racer # nah it's top down and doesn't allow to change keybinds
    # rebels-in-the-sky # meh complex
    # redeclipse # meh crazy controls now?
    ringracers
    rocksndiamonds
    # rpg-cli # eh
    rrootage # very silly
    sauerbraten # split into console/gui? # fails to build in sdl2-compat
    # snes9x-gtk # has to compile now?
    # snis # depends on assets
    # snis-assets # loads of hash mismatches
    sopwith # hehehe
    space-cadet-pinball
    space-station-14-launcher
    # starsector # needs a code
    # haskellPackages.SpaceInvaders # marked as broken
    # haskellPackages.starrover2 # haskell98 is broken
    # speed_dreams # no desktop icon # keeps compiling
    stardust
    # stuntrally # BIG
    # superTux # Bigish
    # superTuxKart # BIG
    surreal-engine
    # the-legend-of-edgar # needs lctrl!
    # tibia # no longer exists!!!
    # titanion # mostly geometry
    # torcs # no desktop icon
    # torus-trooper # aight, mostly fast geometry
    # tremulous # - broken
    # trenchbroom
    # trigger # no desktop icon
    # tumiki-fighters # prisms vs prisms
    # dunno how to launch

    # fails to download anyway
    # ue4demos.black_jack
    # ue4demos.blueprint_examples_demo
    # ue4demos.card_game
    # ue4demos.effects_cave_demo
    # ue4demos.elemental_demo
    # ue4demos.landscape_mountains
    # ue4demos.matinee_demo
    # ue4demos.mobile_temple_demo
    # ue4demos.realistic_rendering
    # ue4demos.reflections_subway
    # ue4demos.scifi_hallway_demo
    # ue4demos.shooter_game
    # ue4demos.strategy_game
    # ue4demos.stylized_demo
    # ue4demos.swing_ninja
    # ue4demos.tappy_chicken
    # ue4demos.vehicle_game
    # uhexen2 # fails to build
    ultimatestunts
    unnamed-sdvx-clone
    unvanquished # tremulous mod?
    # urbanterror # BIG # weirdX
    uqm
    # ut1999 # archive too slow
    # vangers # doesn't read some stuff
    vdrift # big build
    # veloren # error[E0076]: SIMD vector's only field must be an array /build/veloren-0.16.0-vendor/vek-0.17.0/src/quaternion.rs:132:9
    # warsow # ehh... no desktop icon
    # worldofgoo # from steam already
    # xbill # configure: error: installation or configuration problem: C compiler cannot create executables.
    # xgalagapp # small invaderslike
    xonotic
    # xpilot-ng # loads of errors
    yquake2
    # zeroadPackages.zeroad-unwrapped # segfaults
    # zeroadPackages.zeroad-data
    # zsnes
] ++ (if builtins.currentSystem == "x86_64-linux" then [
    steam
    steamcmd
    steam-run
    quake3e
    # vkquake # no desktop icon but needs dir
] else [
   # pkgs-x86_64.quake3e # no desktop icon
   # pkgs-x86_64.vkquake # no desktop icon but needs dir
])
