{ config, pkgs, ... }:
let nixpkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };
  hostname = "almach";
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # systemPackages = import ./packages/packages.nix {pkgs = pkgs; };

  environment.systemPackages = with nixpkgs; [
    # clamav
    rclone
    # docker-compose
    gh
    gitFull
    git-hub
    hub
    git-crypt
    git-lfs
    gnupg
    vim
    mtools
    ddate
    pfsshell
    hamlib
    multimon-ng
    units
    ncspot
    # get_iplayer
    # yt-dlp
    autossh
    bind
    doctl
    irssi
    mailutils
    openvpn
    # ngrok
    cachix
    direnv
    nix-direnv
    nix-index
    nixpkgs-fmt
    atinout
    # lrzsz # c compiler cannot create executables
    # minicom # requires lrzsz
    mnemonicode
    binwalk
    hexedit
    john
    lynis
    masscan
    nmap
    openssl
    sshuttle
    tcpdump
    aha
    # bluez-tools
    cdrtools
    cmatrix
    file
    glances
    hidapi
    htop
    inetutils
    jmtpfs
    jnettop
    logisim-evolution
    lsof
    mono
    ntfs3g
    # openjdk17
    p7zip
    pciutils
    rpiboot
    socat
    testdisk
    unrar
    unzip
    wget
    audacity
    cool-retro-term
    fontforge
    # vscode
    # dosbox # libGL -> mesa broken
    # virt-viewer # fails to find epoxy/egl.h
    gramps
    # geogebra
    # gimp # wrong architecture
    inkscape
    # mplayer # same gl issue
    # dbeaver # too old!
    # postman
    putty
    rdesktop
    scrcpy
    newman
    # OSCAR
    # slack
    # zoom-us
    # xearth # gifout.c:556:3: error: call to undeclared library function 'exit' with type 'void (int) __attribute__((noreturn))'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    # teams # nah never using it
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "/Volumes/Code/system/almach/darwin-configuration.nix";

  # Doesn't install Homebrew. Firstly needs installation:
  # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  homebrew = {
    enable = true;
    brews = [
      "clamav"
      "docker"
      # "docker-compose" # it's a plugin and not a separate package now (follow instructions)x
      # "ext4fuse" # Skipped (no bottle for Apple Silicon)
      "tiger-vnc"
      "wireshark"
    ];
    casks = [
      # "arc" # hmm interesting but nah not for now
      # "blender" # 522
      "browserstacklocal"
      # "chirp" # skip as installed already
      # "clementine" # really crashy???
      # "dbeaver-community" # skip as installed already
      # "firefox" # skip as installed already
      "fugu"
      # "gimp" # skip as installed already
      # "google-chrome" # skip as installed already
      "kapitainsky-rclone-browser"
      "karabiner-elements"
      # "libreoffice" # 404
      # "libreoffice-language-pack" # un-upgradeable
      "lulu"
      # "macfuse"
      # "microsoft-edge" # really now... well it's an option
      #"microsoft-office"
      "microsoft-remote-desktop"
      "oscar"
      # "osxfuse" # The FUSE for macOS installation package is not compatible with this version of macOS.
      # "openmtp" # skip as installed already
      # "slack" # skip as installed already
      # "spotify" # skip as installed already
      "supertuxkart"
      "thunderbird"
      # "transmission" # skip as installed already
      # "tunnelblick" # skip as installed already
      # "visual-studio-code" # skip as installed already
      # "wireshark" # skip as installed already
      "wireshark-chmodbpf"
      # "zoom" # 403
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  networking.hostname = hostname;

  nix.settings.trusted-users = [ "ember" ];
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
