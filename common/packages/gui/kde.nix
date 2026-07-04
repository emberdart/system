pkgs:
(with pkgs; [
    # libsForQt5.plasma-welcome # doesn't exist
    amarok
    plasma-overdose-kde-theme
    plasma-panel-colorizer
    plasma-plugin-blurredwallpaper
    # plasma-theme-switcher # eol p5 only
    qdirstat
    supergfxctl-plasmoid
    systemdgenie
]) ++
(with pkgs.kdePackages; [
    # akregator
    # alligator
    ark
    # artikulate
    # audiotube
    aurorae
    # bomber # failed to build because of libkdegames -> 7zz
    # bovo # failed to build because of libkdegames -> 7zz
    breeze
    breeze-grub
    breeze-gtk
    breeze-icons
    breeze-plymouth
    # discover # no need?
    dolphin
    dolphin-plugins
    # dragon # aeeehhh
    # elisa # ehh
    filelight
    francis
    # full # !!!
    # granatier # failed to build because of libkdegames -> 7zz
    gwenview
    isoimagewriter
    juk
    kaccounts-integration
    kaccounts-providers
    kalarm
    kalgebra
    kalm
    kalzium
    # kamoso # BROKEN
    # kapman # failed to build because of libkdegames -> 7zz
    kasts
    # katomic # failed to build because of libkdegames -> 7zz
    # kauth # ???
    kbackup
    # kblocks # failed to build because of libkdegames -> 7zz
    # kbounce # failed to build because of libkdegames -> 7zz
    # kbreakout # failed to build because of libkdegames -> 7zz
    # kcachegrind # dev stuff
    kcalc
    # kcompletion # ???
    kcron
    kdeplasma-addons
    kdevelop
    kdf
    kdiagram
    # kdiamond # failed to build because of libkdegames -> 7zz
    # kdnssd # lib?
    keysmith
    # kfourinline # failed to build because of libkdegames -> 7zz
    kget
    # kgoldrunner # failed to build because of libkdegames -> 7zz
    # kgpg # dupe
    kgraphviewer
    khangman
    khealthcertificate
    kidletime
    # kig # BROKEN
    # kigo # failed to build because of libkdegames -> 7zz
    # killbots # failed to build because of libkdegames -> 7zz
    kio
    kio-admin # default?
    kio-extras
    kio-extras-kf5
    kio-fuse
    kio-gdrive
    kio-zeroconf
    kirigami
    kirigami-addons
    kirigami-gallery
    # kiriki # failed to build because of libkdegames -> 7zz
    kiten
    # kleopatra # dupe
    # klickety # failed to build because of libkdegames -> 7zz
    # klines # failed to build because of libkdegames -> 7zz
    kmail
    kmail-account-wizard
    # kmines # failed to build because of libkdegames -> 7zz
    kmouth
    kmplot
    # knavalbattle # failed to build because of libkdegames -> 7zz
    # knetwalk # failed to build because of libkdegames -> 7zz
    knewstuff
    # knights # failed to build because of libkdegames -> 7zz
    koko
    # kolf # failed to build because of libkdegames -> 7zz
    kolourpaint
    kompare
    kontact
    konqueror
    # konquest # failed to build because of libkdegames -> 7zz
    konversation
    korganizer
    # kpat # failed to build because of libkdegames -> 7zz
    krdp
    # kreversi # failed to build because of libkdegames -> 7zz
    # ksirk # failed to build because of libkdegames -> 7zz
    # ksshaskpass
    # ksudoku # failed to build because of libkdegames -> 7zz
   #  ksquares # failed to build because of libkdegames -> 7zz
    kteatime
    ktorrent
    ktimer
    kwallet-pam
    kup
    # kwave # BROKEN
    # marble # BROKEN
    merkuro
    minuet
    # neochat # No libolm
    okular
    # picmi # too addictive
    # plasma-applet-commandoutput
    plasma-disks
    # plasma-firewall # we are manually handling this for now
    plasma-browser-integration
    # plasma-panel-spacer-extended
    # plasma-pass
    # ``plasma-thunderbolt
    # plasma-vault # fails
    plasmatube
    plymouth-kcm
    phonon
    # phonon-backend-gstreamer
    # 
    # step # no longer builds
    sweeper
    tokodon
    # wallpaper-engine-plugin # error: Cannot build '/nix/store/prhrqxssyl3c28wip5j55vl7pdkdh29q-wallpaper-engine-kde-plugin-0.5.4-unstable-2025-06-29.drv'
    xdg-desktop-portal-kde # ???
    yakuake
    # kdeconnect-kde # dealt with
    # plasma-hud # nose-1.3.7 not supported for interpreter python3.12
])
