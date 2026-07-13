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
    bomber
    bovo
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
    granatier
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
    kapman
    kasts
    katomic
    # kauth # ???
    kbackup
    kblocks
    kbounce
    kbreakout
    # kcachegrind # dev stuff
    kcalc
    # kcompletion # ???
    kcron
    kdeplasma-addons
    kdevelop
    kdf
    kdiagram
    kdiamond
    # kdnssd # lib?
    keysmith
    kfourinline
    kget
    kgoldrunner
    # kgpg # dupe
    kgraphviewer
    khangman
    khealthcertificate
    kidletime
    # kig # BROKEN
    kigo
    killbots
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
    kiriki
    kiten
    # kleopatra # dupe
    klickety
    klines
    kmail
    kmail-account-wizard
    kmines
    kmouth
    kmplot
    knavalbattle
    knetwalk
    knewstuff
    knights
    koko
    kolf
    kolourpaint
    kompare
    kontact
    konqueror
    konquest
    konversation
    korganizer
    kpat
    krdp
    kreversi
    ksirk
    # ksshaskpass
    ksudoku
    ksquares
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
