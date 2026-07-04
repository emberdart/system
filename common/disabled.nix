 #services.dnscrypt-proxy2 = {
  #  enable = true;
  #  settings = {
  #    ipv6_servers = true;
  #    require_dnssec = true;
  #    sources.public-resolvers = {
  #      urls = [
  #        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
  #        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  #      ];
  #      cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
  #      minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
  #    };
  #    # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
  #    server_names = [
  #      # doh: https://dns.adguard.com/dns-query dot: dns.adguard.com
  #      # adguard-dns-doh
  #      "sdns://AgMAAAAAAAAADzE3Ni4xMDMuMTMwLjEzMCCsFdIhxY-VWoedpSrEKWAhaBEVj-8L-p_FJl6wMpPufg9kbnMuYWRndWFyZC5jb20KL2Rucy1xdWVyeQ"
  #      # ahadns-doh-nl
  #      "sdns://AgMAAAAAAAAACTUuMi43NS43NaAyhv9lpl-vMghe6hOIw3OLp-N4c8kGzOPEootMwqWJiKBETr1nu4P4gHs5Iek4rJF4uIK9UKrbESMfBEz18I33ziDMEGDTnIMptitvvH0NbfkwmGm5gefmOS1c2PpAj02A5hFkb2gubmwuYWhhZG5zLm5ldAovZG5zLXF1ZXJ5"
  #    ];
  #  };
  #};

  #systemd.services.dnscrypt-proxy2.serviceConfig = {
  #  StateDirectory = "dnscrypt-proxy2";
  #};


  #boot.binfmt.emulatedSystems = [
    # "wasm32-wasi"
  #  "wasm64-wasi"
  #  "x86_64-windows"
    # "i686-windows"
    # "i686-linux"
    # "mips64-linux"
    # "mips64el-linux"
    # "sparc64-linux"
    # "aarch64_be-linux"
  #  "aarch64-linux"
  #  "powerpc64-linux"
  #  "riscv64-linux"
  #];

  # services.firefox.syncserver

  /*
  services.ipfs = {
    enable = true;
  };
  */

  /*
  services.jack = {
    jackd = {
      enable = true;
    };
    alsa = {
      enable = true;
    };
    /*
    loopback = {
      enable = true;
    };
  };
  */

  #services.samba.shares = {
  #  public = {
  #    path = "/srv/public";
  #    "read only" = true;
  #    browseable = "yes";
  #    "guest ok" = "yes";
  #    comment = "Public samba share.";
  #  };
  #};


  /* services =

    # xserver.videoDrivers = [ "amdgpu" ];

    #xserver.windowManager.xmonad = {
    #  enable = true;
    #  enableContribAndExtras = true;
    #  config = pkgs.writeText "xmonad.hs" ''
    #    import XMonad
    #    main = xmonad defaultConfig
    #        { terminal    = "urxvt"
    #        , modMask     = mod4Mask
    #        , borderWidth = 3
    #        }
    #  '';
    #  extraPackages = haskellPackages: [
    #    haskellPackages.xmonad-contrib
    #    haskellPackages.monad-logger
    #  ];
    #  haskellPackages = haskell.packages.ghc914;
    #};



    #logcheck = {
    #  enable = true;
    #  level = "paranoid";
    #  mailTo = "logcheck@${domain}";
    #};

    services.i2p = /*
      proto = {
        i2pControl = {
          enable = true;
        };
        i2cp = {
          enable = true;
        };
        sam = {
          enable = true;
        };
        bob = {
          enable = true;
        };
        http = {
          enable = true;
        };
        i2pd = {
          enable = true;
          websocket = {
            enable = true;
          };
        };
      };
      ntcp2 = {
        enable = true;
      };
      upnp = {
        enable = true;
      };

      services =
    #xrdp.enable = true;
    #xrdp.defaultWindowManager = "startplasma-x11";


    (*/


{}