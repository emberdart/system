{ pkgs, hostname, hostDir, privateDir, homeDirectory, username, domain, isDesktop, internalIPv4, localIPv6, globalIPv6, ... }:
let
  # needs /persist, see: https://github.com/nix-community/impermanence/issues/87
  rootDir = "${homeDirectory}/code/mine/nix/system";
  haskellSites = "${homeDirectory}/code/mine/haskell";
  roqHome = "${homeDirectory}/code/work/roqqett";
  websites = "${haskellSites}/websites/.sites";
  keyId = "0240A2F45637C90C";
in {
  services = {
    cron = {
      enable = true;
      # mailto = "cron@${domain}";
      systemCronJobs = [
        # see https://www.freebsd.org/cgi/man.cgi?crontab%285%29 for special:
        #@weekly @monthly @yearly @annually @hourly @daily @reboot
        #m h d m w
        "0 * * * * ember  RESULT=$(nix-channel --update 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        "0 * * * * root RESULT=$(nix-channel --update 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        "0 */2 * * * root RESULT=$(cd ${rootDir}/${hostname} && $PWD/../common/scripts/upgrade.sh 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId} || echo System updated. | gpg -ae -r ${keyId}"
        "0 2 * * * ember RESULT=$(cd ~/code; ./build-cabal.sh; 2>&1); [ 0 != $? ] && echo $RESULT" #  | gpg -ae -r ${keyId}"
        # TODO should we make this per project? per user?
        # "0 2 * * * ember RESULT=$(cd ~/code; ./build-nix.sh; ./build-nix.sh 24; 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # Backup everything to USB hourly - TODO cloud backups but passwordless? Or take password from another service?
        # TODO also include .config/rclone once it exists
        "0 * * * * ember RESULT=$(cd ~; if [ -d /run/media/ember/Backup ]; then for i in Desktop/ Documents/ Music/ Pictures/ Public/ Videos/ .gnupg/ .ssh/; do rsync -auvP $i /run/media/ember/Backup/$i 2>&1; done; else echo No disk present or not mounted.; fi); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # scorpii.home.emberdart.co.uk
        #"*/10 * * * * ember IP=$(ip -6 addr show dev wlp0s20f3 scope global | awk '/inet6/{print $2}' | grep '::' | cut -d / -f 1); RESULT=$(doctl compute domain records update emberdart.co.uk --record-id 1747775271 --record-data $IP 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # home.emberdart.co.uk
        # "0 * * * * ember IP=$(curl https://api.ipify.org 2>/dev/null); RESULT=$(doctl compute domain records update emberdart.co.uk --record-id 1736676743 --record-data $IP 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # scorpii.emberdart.co.uk (IPv6)
        #"*/10 * * * * ember IP=$(ip -6 addr show dev wlp0s20f3 scope global | awk '/inet6/{print $2}' | grep '::' | cut -d / -f 1); RESULT=$(doctl compute domain records update emberdart.co.uk --record-id 1750535304 --record-data $IP 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # scorpii.emberdart.co.uk (IPv4)
        # "0 * * * * ember IP=$(curl https://api.ipify.org 2>/dev/null); RESULT=$(doctl compute domain records update emberdart.co.uk --record-id 1750535231 --record-data $IP 2>&1); [ 0 != $? ] && echo $RESULT | gpg -ae -r ${keyId}"
        # emberdart.geek
        #"*/10 * * * * ember IP=$(ip -6 addr show dev wlp0s20f3 scope global | awk '/inet6/{print $2}' | grep '::' | cut -d / -f 1); TOKEN=$(curl http://be.libre | grep token | cut -d \"'\" -f 6); curl -X POST -c /tmp/cookie -d \"token=$TOKEN&submit=Sign+in&user=${builtins.readFile "${privateDir}/belibre/user"}&pass=${builtins.readFile "${privateDir}/belibre/pass"})\" http://be.libre; TOKEN=$(curl -b /tmp/cookie http://be.libre | grep token | cut -d \"'\" -f 6); curl -X POST -b /tmp/cookie -d \"token=$TOKEN&submit=Update&submit_page=edit_domain&domain[dandart.geek][AAAA][0]=$IP\" \"http://be.libre/?dc=dandart,dc=geek\""
      ];
    };

    octoprint = {
      enable = true;
      plugins = plugins: with plugins; [ themeify stlviewer ];
    };

    supergfxd = if isDesktop then {
      enable = true;
      settings = {
        vfio_enable = "true";
        hotplug_type = "asus";
      };
    } else {};

    logrotate.checkConfig = false; # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/

    earlyoom = {
      enable = true;
      enableNotifications = true;
      freeSwapThreshold = 5;
      freeMemThreshold = 5;
      # useKernelOOMKiller = false;
    };

    # This seems to be quite fucky sometimes. Just run `sudo envfs /bin; sudo envfs /usr/bin` if you get issues with transport endpoint.
    # envfs.enable = true;

    freenet = {
      # enable = true;
    };

    fwupd = {
      enable = true;
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
      discovery = true;
    };

    vscode-server.enable = true;

    # dropped - https://github.com/NixOS/nixpkgs/issues/465407
    # preload.enable = true;

    # needs a smbpasswd -a ember
    samba = {
      enable = true;
      nsswins = true;
      nmbd = {
        enable = true;
      };
      winbindd = {
        enable = true;
      };
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 192.168.1. 127.0.0.1 localhost ::1 2a0b:5f04:16e:1200:: fd6c:5095:66e8:: fe80::";
          "hosts deny" = "0.0.0.0/0 ::/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        public = {
          path = "${homeDirectory}/Public";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "ember";
          "force group" = "users";
        };
        private = {
          path = homeDirectory;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "ember";
          "force group" = "users";
        };
        drives = {
          path = "/run/media/${username}";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = username;
          "force group" = "users";
        };
      };
    };

    usbmuxd = {
      enable = true;
    };

    # i2p = {
    #   enable = true;
    # };
  # 
    # i2pd = {
    #   enable = true;
  # 
    #   websocket = {
    #     enable = true;
    #   };
  # 
    #   proto = {
    #     i2pControl = {
    #       enable = true;
    #     };
    #     i2cp = {
    #       enable = true;
    #     };
    #     sam = {
    #       enable = true;
    #     };
    #     bob = {
    #       enable = true;
    #     };
    #     http = {
    #       enable = true;
    #     };
    #   };
  # 
    #   ntcp2 = {
    #     enable = true;
    #   };
  # 
    #   upnp = {
    #     enable = true;
    #   };
    # };

    # tailscale = {
    #   enable = true;
    # };

    tor = {
      enable = true;
      client = {
        enable = true;
      };
      enableGeoIP = false;
      # backup /var/lib/tor/onion/myOnion
      relay = {
        onionServices = {
          myOnion = {
            version = 3;
            map = [{
              port = 80;
              target = {
                addr = "[::1]";
                port = 80;
              };
            }];
          };
        };
      };
      settings = {
        ClientUseIPv4 = true;
        ClientUseIPv6 = true;
        ClientPreferIPv6ORPort = true;
        HttpTunnelPort = 8118;
        # SOCKSPort = [
        #   {
        #     port = 9050;
        #   }
        # ];
      };
    };

    # zeronet = {
    #   enable = true;
    #   torAlways = true;
    # };

    # logcheck = {
    #   enable = true;
    #   level = "paranoid";
    #   mailTo = "logcheck@${domain}";
    # };

    nix-serve = if isDesktop then {} else {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };

    logind = {
      settings = {
        Login = {
          HandleLidSwitch = "lock";
          HandleLidSwitchDocked = "lock";
        };
      };
      # lidSwitchExternalPower = "lock";
    };

    upower = {
      enable = true;
    };

    desktopManager = if isDesktop then {
      plasma6 = {
        enable = true;
      };
    } else {};

    displayManager = if isDesktop then {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
        #autoLogin = {
        #  relogin = true;
        #};
      };
      #autoLogin = {
        # enable = true;
        # user = username;
      #};
      #surf-display = {
      #  enable = true;
      #};
      #retroarch = {
      #  enable = true;
      #};
      #kodi = {
      #  enable = true;
      #}
    } else {};


    libinput = {
      enable = isDesktop;
      touchpad = {
        sendEventsMode = "disabled-on-external-mouse";
      };
    };

    xserver = if isDesktop then {
      enable = true;
      
      # desktopManager = {
      #   #plasma5 = {
      #   #  enable = true;
      #   #};
      #   #cinnamon = {
      #   #  enable = true;
      #   #};
      #   #enlightenment = {
      #   #  enable = true;
      #   #};
      # };
      xkb = {
        layout = "gb";
        # model = "inspiron";
        options = "terminate:ctrl_alt_bksp,caps:escape,compose:ralt";
      };
    } else {};

    #cinnamon = {
    #  apps = {
    #    enable = true;
    #  };
    #};

    gvfs = {
      enable = isDesktop;
    };

    # touchegg = {
    #   enable = isDesktop && isTouchscreen;
    # };

    # BIG BUG HERE: https://github.com/NixOS/nixpkgs/issues/126374
    # tt-rss = {
    #   enable = true;
    #   enableGZipOutput = true;
    #   database = {
    #     # for permissions we'll read and send instead of using passwordFile.
    #     password = builtins.readFile "${privateDir}/tt-rss/dbpass";
    #   };
    #   #auth = {
    #     # autoCreate = true;
    #     # autoLogin = true;
    #   #};
    #   email = {
    #     fromName = "tt-rss";
    #     fromAddress = builtins.readFile "${privateDir}/tt-rss/email_from_address";
    #     login = builtins.readFile "${privateDir}/tt-rss/email_login";
    #     password = builtins.readFile "${privateDir}/tt-rss/email_password";
    #     security = "tls";
    #     server = builtins.readFile "${privateDir}/tt-rss/email_server";
    #   };
    #   #registration = {
    #   #  enable = true;
    #   #  maxUsers = 1;
    #   #};
    #   selfUrlPath = "https://news.${domain}";
    #   # singleUserMode = true;
    #   virtualHost = "news.${domain}";
    # };

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
    #  haskellPackages = pkgs.haskell.packages.ghc914;
    #};

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;

    # TODO
    # why is this x86_64 only???
    # onlyoffice = let rabbitMQPassword = builtins.readFile "${privateDir}/rabbitmq/password";
    # in {
    #   enable = true;
    #   hostname = "office.${domain}";
    #   port = 8000;
    #   rabbitmqUrl = "amqp://rabbitmq:${rabbitMQPassword}@localhost:5672";
    #   # postgresHost = "localhost";
    #   postgresName = "onlyoffice";
    #   # postgresUser = "onlyoffice";
    #   # postgresPasswordFile = "${privateDir}/onlyoffice/dbpass";
    #   jwtSecretFile = "${privateDir}/onlyoffice/jwtsecret";
    # };

    szurubooru = {
      enable = false;
      server = {
        settings = {
          name = "Degenerate Board";
          domain = "https://degenerate.tsumikimikan.com";
          secretFile = "${privateDir}/szuru/secret";
          allow_broken_uploads = true;
          debug = 1;
          smtp = {
            user = builtins.readFile "${privateDir}/mail/user";
            port = 993;
            passFile = "${privateDir}/mail/pass";
            host = builtins.readFile "${privateDir}/mail/host";
            from = "szurubooru@${domain}";
          };
          enable_safety = "no";

        };
        port = 9200;
      };
      database = {
        user = "szurubooru";
        port = 5432;
        name = "szuru";
        host = "localhost";
        passwordFile = "${privateDir}/szuru/dbpass";
      };
    };

    fprintd = {
      enable = true;
    };

    nginx = {
      enable = true;
      # enableReload = true;
      defaultListenAddresses = [
        "127.0.0.1"
        "[::1]"
        internalIPv4
        # "${externalIPv4}" # not for desktop anymore
        "[${localIPv6}]"
        # # "[${globalIPv6}]"
        "0.0.0.0"
        "[::]"
      ];
      statusPage = true;
      recommendedProxySettings = true;
      # sso = {};
      # too many server names
      serverNamesHashBucketSize = 128;
      virtualHosts = {
        "localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          root = "${hostDir}/private_html";
        };
        "${hostname}.local" = {
          listenAddresses = [
            internalIPv4
            "[${localIPv6}]"
          ];
          root = "${hostDir}/network_html";
        };
        "${hostname}.${domain}" = {
          root = "${hostDir}/public_html";
        };
        "m0ori.ampr.org" = {
          listenAddresses = [
            "44.63.0.51"
          ];
          root = "${hostDir}/radio_html";
        };
        # "${hostname}.${if isDesktop then ".home" else ""}${domain}" = {
        #   default = true;
        #   forceSSL = true;
        #   # enableACME = true;
        #   useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
        #   serverAliases = [
        #   ];
        #   root = "${hostDir}/public_html";
        # };
        "${hostname}.${if isDesktop then "home." else ""}${domain}" = {
          default = true;
          forceSSL = true;
          # forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          listenAddresses = [
            "[::1]"
            "[${localIPv6}]"
            # # "[${globalIPv6}]"
            "[::]"
          ];
          serverAliases = [
          ];
          root = "${hostDir}/public_html";
        };
        # "opennic-website" = {
        #   # todo fix
        #   # forceSSL = true;
        #   # addSSL = true;
        #   # enableACME = true;
        #   # useACMEHost = "opennic";
        #   listenAddresses = [
        #     "127.0.0.1"
        #     "[::1]"
        #     "[${localIPv6}]"
        #     # # "[${globalIPv6}]"
        #     "[::]"
        #   ];
        #   root = "${hostDir}/geek_html";
        # };
        # "opennic-website.localhost" = {
        #   listenAddresses = [
        #     "127.0.0.1"
        #     "[::1]"
        #   ];
        #   root = "${hostDir}/geek_html";
        # };
        "${builtins.readFile "${privateDir}/tor_url"}" = {
          listenAddresses = [
            "[::1]"
          ];
          root = "${hostDir}/tor_html";
        };
        #"nextcloud.${domain}" = {
          # http3 = true;
        #  forceSSL = true;
        #  # enableACME = true;
        #};
        # "news.${domain}" = {
        #   # http3 = true;
        #   forceSSL = true;
        #   useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
        #   # enableACME = true;
        # };
        #"dev.localhost" = {
        #  # http3 = true;
        #  forceSSL = true;
        #  sslCertificate = "${roqHome}/roqqett-web-api/certs/dev-localhost-cert.pem";
        #  sslCertificateKey = "${roqHome}/roqqett-web-api/certs/dev-localhost-key.pem";
        #  serverAliases = [];
        #  extraConfig = ''
        #    error_page 502 /502.html;
        #  '';
        #  locations = {
        #    "/" = {
        #      proxyPass = "http://localhost:5000/";
        #      proxyWebsockets = true;
        #    };
        #    "/502.html" = {
        #      root = "${roqHome}/Data/static/";
        #    };
        #  };
        #};
        # "roqqett.${domain}" = {
        #   # http3 = true;
        #   forceSSL = true;
        #   # enableACME = true;
        #   useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
        #   serverAliases = [
        #     "roqqett.home.${domain}"
        #     # "roqqett.dandart.uk"
        #   ];
        #   extraConfig = ''
        #     error_page 502 /502.html;
        #   '';
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://localhost:5000/";
        #       proxyWebsockets = true;
        #     };
        #     "/502.html" = {
        #       root = "${roqHome}/Data/static/";
        #     };
        #   };
        # };
        # "roq-wp.${domain}" = {
        #   # http3 = true;
        #   forceSSL = true;
        #   # enableACME = true;
        #   useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
        #   # serverAliases = [
        #   #   "roq-wp.dandart.uk"
        #   # ];
        #   extraConfig = ''
        #     error_page 502 /502.html;
        #   '';
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://localhost:5600/";
        #       proxyWebsockets = true;
        #     };
        #     "/502.html" = {
        #       root = "${roqHome}/Data/static/";
        #     };
        #   };
        # };
        "dev.${domain}" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/personal";
              proxyWebsockets = true;
            };
          };
        };
        "emberdart.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/personal";
              proxyWebsockets = true;
            };
          };
        };
        "dev.dandart.co.uk" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/deadsite";
              proxyWebsockets = true;
            };
          };
        };
        "dandart.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/deadsite";
              proxyWebsockets = true;
            };
          };
        };
        "dev.jolharg.com" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/portfolio";
              proxyWebsockets = true;
            };
          };
        };
        "jolharg.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/portfolio";
              proxyWebsockets = true;
            };
          };
        };
        "dev.blog.jolharg.com" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogtech";
              proxyWebsockets = true;
            };
          };
        };
        "blog.jolharg.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogtech";
              proxyWebsockets = true;
            };
          };
        };
        "dev.madhackerreviews.com" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/reviews";
              proxyWebsockets = true;
            };
          };
        };
        "madhackerreviews.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/reviews";
              proxyWebsockets = true;
            };
          };
        };
        "dev.m0ori.com" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/hamradio";
              proxyWebsockets = true;
            };
          };
        };
        "m0ori.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/hamradio";
              proxyWebsockets = true;
            };
          };
        };
        "dev.blog.m0ori.com" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/bloghamradio";
              proxyWebsockets = true;
            };
          };
        };
        "blog.m0ori.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/bloghamradio";
              proxyWebsockets = true;
            };
          };
        };
        "dev.blog.${domain}" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogpersonal";
              proxyWebsockets = true;
            };
          };
        };
        "blog.emberdart.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogpersonal";
              proxyWebsockets = true;
            };
          };
        };
        "dev.blog.dandart.co.uk" = {
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogdead";
              proxyWebsockets = true;
            };
          };
        };
        "blog.dandart.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${websites}/blogdead";
              proxyWebsockets = true;
            };
          };
        };
        "dev.jobfinder.jolharg.com" = {
          # http3 = true;
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          # htaccess?
          extraConfig = ''
            error_page 404 /index.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${haskellSites}/jobfinder/src/ui/build/dev";
              # root = "${haskellSites}/jobfinder/src/ui/dist-newstyle/build/javascript-ghcjs/ghc-9.12.2/ui-0.2.0.0/x/ui-dev/build/ui-dev/ui-dev.jsexe";
              proxyWebsockets = true;
            };
            "/api/" = {
              proxyPass = "http://localhost:8082/api/";
            };
          };
        };
        "dev.jobfinder.jolharg.localhost" = {
          extraConfig = ''
            error_page 404 /index.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${haskellSites}/jobfinder/src/ui/build/dev";
              # root = "${haskellSites}/jobfinder/src/ui/dist-newstyle/build/javascript-ghcjs/ghc-9.12.2/ui-0.2.0.0/x/ui-dev/build/ui-dev/ui-dev.jsexe";
              proxyWebsockets = true;
            };
            "/api/" = {
              proxyPass = "http://localhost:8082/api/";
            };
          };
        };
        "jobfinder.jolharg.com" = {
          # http3 = true;
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          # htaccess?
          extraConfig = ''
            error_page 404 /index.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              root = "${haskellSites}/jobfinder/src/ui/build/prod";
              # root = "${haskellSites}/jobfinder/src/ui/dist-newstyle/build/javascript-ghcjs/ghc-9.12.2/ui-0.2.0.0/x/ui/build/ui/ui.jsexe";
              proxyWebsockets = true;
            };
            "/api/" = {
              proxyPass = "http://localhost:8081/api/";
            };
          };
        };
        "jobfinder.jolharg.localhost" = {
          extraConfig = ''
            error_page 404 /index.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              root = "${haskellSites}/jobfinder/src/ui/build/prod";
              # root = "${haskellSites}/jobfinder/src/ui/dist-newstyle/build/javascript-ghcjs/ghc-9.12.2/ui-0.2.0.0/x/ui/build/ui/ui.jsexe";
              proxyWebsockets = true;
            };
            "/api/" = {
              proxyPass = "http://localhost:8081/api/";
            };
          };
        };
        "api.jobfinder.jolharg.com" = {
          # http3 = true;
          forceSSL = true;
          # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          extraConfig = ''
            error_page 502 /502.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              proxyPass = "http://localhost:8081/";
              proxyWebsockets = true;
            };
            "/502.html" = {
              root = "${haskellSites}/jobfinder/src/api/data";
            };
          };
        };
        "api.jobfinder.jolharg.localhost" = {
          extraConfig = ''
            error_page 502 /502.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              proxyPass = "http://localhost:8081/";
              proxyWebsockets = true;
            };
            "/502.html" = {
              root = "${haskellSites}/jobfinder/src/api/data";
            };
          };
        };
        "api.dev.jobfinder.jolharg.com" = {
          # http3 = true;
          forceSSL = true;
          # # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          extraConfig = ''
            error_page 502 /502.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/" = {
              proxyPass = "http://localhost:8082/";
              proxyWebsockets = true;
            };
            "/502.html" = {
              root = "${haskellSites}/jobfinder/src/api/data";
            };
          };
        };
        "api.dev.jobfinder.jolharg.localhost" = {
          extraConfig = ''
            error_page 502 /502.html;
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/" = {
              proxyPass = "http://localhost:8082/";
              proxyWebsockets = true;
            };
            "/502.html" = {
              root = "${haskellSites}/jobfinder/src/api/data";
            };
          };
        };
        "degenerate.tsumikimikan.com" = {
          # http3 = true;
          forceSSL = true;
          # # enableACME = true;
          useACMEHost = "${hostname}.${if isDesktop then "home." else ""}${domain}"; # security.acme.certs
          serverAliases = [];
          extraConfig = ''
          '';
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
            "[${localIPv6}]"
            # "[${globalIPv6}]"
            "[::]"
          ];
          locations = {
            "/api/" = {
              proxyPass = "http://localhost:9200/";
            };
            "/data/" = {
              root = "/var/lib/szurubooru";
            };
            "/" = {
              root = pkgs.szurubooru.client;
              tryFiles = "$uri /index.htm";
            };
          };
        };
        "degenerate.tsumikimikan.localhost" = {
          listenAddresses = [
            "127.0.0.1"
            "[::1]"
          ];
          locations = {
            "/api/" = {
              proxyPass = "http://localhost:9200/";
            };
            "/data/" = {
              root = "/var/lib/szurubooru";
            };
            "/" = {
              root = pkgs.szurubooru.client;
              tryFiles = "$uri /index.htm";
            };
          };
        };
        
        # "cache.jolharg.com" = {
        #   # http3 = true;
        #   forceSSL = true;
        #   # enableACME = true;
        #   serverAliases = [];
        #   extraConfig = ''
        #     error_page 502 /502.html;
        #   '';
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://localhost:5000";
        #     };
        #   };
        # };
        # "appbuilder.jolharg.com" = {
        #   # http3 = true;
        #   forceSSL = true;
        #   # enableACME = true;
        #   serverAliases = [];
        #   extraConfig = ''
        #     error_page 502 /502.html;
        #   '';
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://localhost:3000";
        #     };
        #   };
        # };
      };
    };

    # github-runners = {
    #   jolharg = {
    #     enable = true;
    #     url = "https://github.com/JolHarg";
    #     tokenFile = ./private/github/runners/jolharg.token;
    #     nodeRuntimes = [ "node16" "node20" ];
    #   };
    # };

    # broken

    # php fails now?
    # grocy = {
    #   enable = true;
    #   hostname = "grocy.${domain}";
    #   nginx = {
    #     # forceSSL = true;
    #   };
    #   settings = {
    #     calendar = {
    #       firstDayOfWeek = 1;
    #     };
    #     currency = "GBP";
    #     culture = "en_GB";
    #   };
    # };

    # doesn't build and I don't use it anyway
    # home-assistant = {
    #   enable = true;
    #   openFirewall = true; # todo which ports other than 8123
    #   config = {
    #     homeassistant = {
    #       unit_system = "metric";
    #       time_zone = "Europe/London";
    #       temperature_unit = "C";
    #       name = "${hostname}";
    #       longitude = -2.5;
    #       latitude = 51.2;
    #     };
    #   };
    #   # ok these are super out of date
    #   extraComponents = [
    # #     "abode"
    # #     "accuweather"
    # #     "acer_projector"
    # #     "acmeda"
    # #     "actiontec"
    # #     "adax"
    #     "adguard"
    #     "ads"
    # #     "advantage_air"
    # #     "aemet"
    # #     "aftership"
    # #     "agent_dvr"
    #     "air_quality"
    # #     "airly"
    #     "airnow"
    # #     "airthings"
    # #     "airtouch4"
    # #     "airvisual"
    # #     "airzone"
    # #     "aladdin_connect"
    # #     "alarm_control_panel"
    # #     "alarmdecoder"
    #     "alert"
    # #     "alexa"
    # #     "almond"
    # #     "alpha_vantage"
    # #     "amazon_polly"
    # #     "amberelectric"
    # #     "ambiclimate"
    # #     "ambient_station"
    # #     "amcrest"
    # #     "ampio"
    #     "analytics"
    # #     "android_ip_webcam"
    # #     "androidtv"
    # #     "anel_pwrctrl"
    # #     "anthemav"
    # #     "apache_kafka"
    # #     "apcupsd"
    # #     "api"
    # #     "apple_tv"
    # #     "application_credentials"
    # #     "apprise"
    # #     "aprs"
    # #     "aqualogic"
    # #     "aquostv"
    # #     "arcam_fmj"
    # #     "arest"
    # #     "arris_tg2492lg"
    # #     "aruba"
    # #     "arwn"
    # #     "aseko_pool_live"
    # #     "asterisk_cdr"
    # #     "asterisk_mbox"
    #     "asuswrt"
    # #     "atag"
    # #     "aten_pe"
    # #     "atome"
    # #     "august"
    # #     "aurora"
    # #     "aurora_abb_powerone"
    # #     "aussie_broadband"
    # #     "auth"
    #     "automation"
    # #     "avea"
    # #     "avion"
    # #     "awair"
    # #     "aws"
    # #     "axis"
    # #     "azure_devops"
    # #     "azure_event_hub"
    # #     "azure_service_bus"
    #     "backup"
    # #     "baf"
    # #     "baidu"
    # #     "balboa"
    # #     "bayesian"
    # #     "bbox"
    # #     "beewi_smartclim"
    # #     "binary_sensor"
    # #     "bitcoin" # error: future-1.0.0 not supported for interpreter python3.13
    # #     "bizkaibus"
    # #     "blackbird"
    # #     "blebox"
    # #     "blink"
    # #     "blinksticklight"
    # #     "blockchain" # error: future-1.0.0 not supported for interpreter python3.13
    # #     "bloomsky"
    # #     "bluemaestro"
    # #     "blueprint"
    # #     "bluesound"
    # #     "bluetooth"
    #     "bluetooth_le_tracker"
    #     "bluetooth_tracker"
    # #     "bmw_connected_drive"
    # #     "bond"
    # #     "bosch_shc"
    #     "braviatv"
    # #     "broadlink"
    # #     "brother"
    # #     "brottsplatskartan"
    #     "browser"
    # #     "brunt"
    # #     "bsblan"
    # #     "bt_home_hub_5"
    # #     "bt_smarthub"
    # #     "bthome"
    # #     "buienradar"
    # #     "button"
    #     "caldav"
    #     "calendar"
    #     "camera"
    # #     "canary"
    #     "cast"
    #     "cert_expiry"
    # #     "channels"
    # #     "circuit"
    # #     "cisco_ios"
    # #     "cisco_mobility_express"
    # #     "cisco_webex_teams"
    # #     "citybikes"
    #     "clementine"
    # #     "clickatell"
    # #     "clicksend"
    # #     "clicksend_tts"
    # #     "climate"
    # #     "cloud"
    # #     "cloudflare"
    # #     "cmus"
    # #     "co2signal"
    #     "coinbase"
    # #     "color_extractor"
    # #     "comed_hourly_pricing"
    # #     "comfoconnect"
    #     "command_line"
    # #     "compensation"
    # #     "concord232"
    # #     "config"
    # #     "configurator"
    # #     "control4"
    # #     "conversation"
    # #     "coolmaster"
    # #     "counter"
    # #     "cover"
    # #     "cppm_tracker"
    # #     "cpuspeed"
    # #     "crownstone"
    # #     "cups"
    # #     "currencylayer"
    # #     "daikin"
    # #     "danfoss_air"
    # #     "darksky"
    # #     "datadog"
    # #     "ddwrt"
    # #     "debugpy"
    # #     "deconz"
    # #     "decora"
    # #     "decora_wifi"
    # #     "default_config"
    # #     "delijn"
    # #     "deluge"
    #     "demo"
    # #     "denon"
    # #     "denonavr"
    # #     "derivative"
    # #     "deutsche_bahn"
    # #     "device_automation"
    # #     "device_sun_light_trigger"
    #     "device_tracker"
    # #     "devolo_home_control"
    # #     "devolo_NET4work"
    # #     "dexcom"
    #     "dhcp"
    #     "diagnostics"
    # #     "dialogflow"
    # #     "digital_ocean"
    # #     "directv"
    # #     "discogs"
    #     "discord"
    # #     "discovery"
    # #     "dlib_face_detect"
    # #     "dlib_face_identify"
    #     "dlink"
    #     "dlna_dmr"
    #     "dlna_dms"
    #     "dnsip"
    #     "dominos"
    # #     "doods"
    # #     "doorbird"
    # #     "dovado"
    # #     "downloader"
    # #     "dsmr"
    # #     "dsmr_reader"
    # #     "dte_energy_bridge"
    # #     "dublin_bus_transport"
    # #     "duckdns"
    # #     "dunehd"
    # #     "dwd_weather_warnings"
    # #     "dweet"
    # #     "dynalite"
    # #     "eafm"
    # #     "ebox"
    # #     "ebusd"
    # #     "ecoal_boiler"
    # #     "ecobee"
    # #     "econet"
    # #     "ecovacs"
    # #     "ecowitt"
    # #     "eddystone_temperature"
    # #     "edimax"
    # #     "edl21"
    # #     "efergy"
    # #     "egardia"
    # #     "eight_sleep"
    # #     "elgato"
    # #     "eliqonline"
    # #     "elkm1"
    # #     "elmax"
    # #     "elv"
    # #     "emby"
    # #     "emoncms"
    # #     "emoncms_history"
    # #     "emonitor"
    # #     "emulated_hue"
    # #     "emulated_kasa"
    # #     "emulated_roku"
    #     "energy"
    # #     "enigma2"
    # #     "enocean"
    # #     "enphase_envoy"
    # #     "entur_public_transport"
    # #     "environment_canada"
    # #     "envisalink"
    # #     "ephember"
    # #     "epson"
    # #     "epsonworkforce"
    # #     "eq3btsmart"
    # #     "escea"
    # #     "esphome"
    # #     "etherscan"
    # #     "eufy"
    # #     "everlights"
    # #     "evil_genius_labs"
    # #     "evohome"
    # #     "ezviz"
    # #     "faa_delays"
    # #     "facebook"
    # #     "facebox"
    #     "fail2ban"
    # #     "familyhub"
    # #     "fan"
    # #     "fastdotcom"
    #     "feedreader"
    #     "ffmpeg"
    #     "ffmpeg_motion"
    #     "ffmpeg_noise"
    # #     "fibaro"
    # #     "fido"
    #     "file"
    #     "file_upload"
    #     "filesize"
    #     "filter"
    # #     "fints"
    # #     "fireservicerota"
    # #     "firmata"
    # #     "fitbit"
    # #     "fivem"
    # #     "fixer"
    # #     "fjaraskupan"
    # #     "fleetgo"
    # #     "flexit"
    # #     "flic"
    # #     "flick_electric"
    # #     "flipr"
    # #     "flo"
    # #     "flock"
    # #     "flume"
    # #     "flux"
    # #     "flux_led"
    #     "folder"
    #     "folder_watcher"
    # #     "foobot"
    #     "forecast_solar"
    #     "forked_daapd"
    # #     "fortios"
    # #     "foscam"
    # #     "foursquare"
    # #     "free_mobile"
    # #     "freebox"
    # #     "freedns"
    # #     "freedompro"
    # #     "fritz"
    # #     "fritzbox"
    # #     "fritzbox_callmonitor"
    # #     "fronius"
    #     "frontend"
    # #     "frontier_silicon"
    #     "fully_kiosk"
    # #     "futurenow"
    # #     "garadget"
    # #     "garages_amsterdam"
    # #     "gc100"
    # #     "gdacs"
    #     "generic"
    # #     "generic_hygrostat"
    # #     "generic_thermostat"
    # #     "geniushub"
    #     "geo_json_events"
    #     "geo_location"
    #     "geo_rss_events"
    #     "geocaching"
    # #     "geofency"
    # #     "geonetnz_quakes"
    # #     "geonetnz_volcano"
    # #     "gios"
    #     "github"
    # #     "gitlab_ci"
    # #     "gitter"
    #     "glances"
    # #     "goalfeed"
    # #     "goalzero"
    # #     "gogogate2"
    # #     "goodwe"
    #     "google"
    # #     "google_assistant"
    # #     "google_cloud"
    # #     "google_domains"
    #     "google_maps"
    # #     "google_pubsub"
    #     "google_sheets"
    #     "google_translate"
    #     "google_travel_time"
    # #     "google_wifi"
    # #     "govee_ble"
    # #     "gpsd"
    # #     "gpslogger"
    # #     "graphite"
    # #     "gree"
    # #     "greeneye_monitor"
    # #     "greenwave"
    # #     "group"
    # #     "growatt_server"
    #     "gstreamer"
    # #     "gtfs"
    # #     "guardian"
    # #     "habitica"
    # #     "hangouts"
    #     "hardkernel"
    # #     "hardware"
    # #     "harman_kardon_avr"
    # #     "harmony"
    # #     "hassio"
    #     "haveibeenpwned"
    #     "hddtemp"
    #     "hdmi_cec"
    # #     "heatmiser"
    # #     "heos"
    # #     "here_travel_time"
    # #     "hikvision"
    # #     "hikvisioncam"
    # #     "hisense_aehw4a1"
    # #     "history"
    # #     "history_stats"
    # #     "hitron_coda"
    # #     "hive"
    # #     "hlk_sw16"
    # #     "home_connect"
    # #     "home_plus_control"
    #     "homeassistant"
    #     "homeassistant_alerts"
    # #     "homeassistant_sky_connect"
    # #     "homeassistant_yellow"
    # #     "homekit"
    # #     "homekit_controller"
    # #     "homematic"
    # #     "homematicip_cloud"
    # #     "homewizard"
    # #     "homeworks"
    # #     "honeywell"
    # #     "horizon"
    # #     "hp_ilo"
    #     "html5"
    #     "http"
    # #     "huawei_lte"
    # #     "hue"
    # #     "huisbaasje"
    # #     "humidifier"
    # #     "hunterdouglas_powerview"
    # #     "hvv_departures"
    # #     "hydrawise"
    # #     "hyperion"
    # #     "ialarm"
    # #     "iammeter"
    # #     # "iaqualink" # broken
    # #     "ibeacon"
    # #     "icloud"
    # #     "idteck_prox"
    #     "ifttt"
    # #     "iglo"
    # #     "ign_sismologia"
    # #     "ihc"
    #     "image"
    #     "image_processing"
    #     "imap"
    # #     "incomfort"
    # #     "influxdb"
    # #     "inkbird"
    #     "input_boolean"
    #     "input_button"
    #     "input_datetime"
    #     "input_number"
    #     "input_select"
    #     "input_text"
    # #     "insteon"
    # #     "integration"
    # #     "intellifire"
    #     "intent"
    #     "intent_script"
    # #     "intesishome"
    # #     "ios"
    # #     "iotawatt"
    # #     "iperf3"
    # #     "ipma"
    # #     "ipp"
    # #     "iqvia"
    # #     "irish_rail_transport"
    # #     "islamic_prayer_times"
    # #     "iss"
    # #     "isy994"
    # #     "itach"
    # #     "itunes"
    # #     "izone"
    # #     "jellyfin"
    # #     "jewish_calendar"
    # #     "joaoapps_join"
    # #     "juicenet"
    # #     "justnimbus"
    # #     "kaiterra"
    # #     "kaleidescape"
    # #     "kankun"
    # #     "keba"
    # #     "keenetic_ndms2"
    # #     "kef"
    # #     "kegtron"
    #     "keyboard"
    #     "keyboard_remote"
    # #     "keymitt_ble"
    # #     "kira"
    # #     "kiwi"
    # #     "kmtronic"
    # #     "knx"
    #     "kodi"
    # #     "konnected"
    # #     "kostal_plenticore"
    # #     "kraken"
    # #     "kulersky"
    # #     "kwb"
    # #     "lacrosse"
    # #     "lacrosse_view"
    # #     "lametric"
    # #     "landisgyr_heat_meter"
    # #     "lannouncer"
    #     "lastfm"
    # #     "launch_library"
    # #     "laundrify"
    # #     "lcn"
    # #     "led_ble"
    # #     "lg_netcast"
    # #     "lg_soundbar"
    # #     "lidarr"
    # #     "life360"
    # #     "lifx"
    # #     "lifx_cloud"
    # #     "light"
    # #     "lightwave"
    # #     "limitlessled"
    # #     "linksys_smart"
    # #     "linode"
    #     "linux_battery"
    # #     "lirc"
    # #     "litejet"
    # #     "litterrobot"
    # #     "llamalab_automate"
    #     "local_file"
    #     "local_ip"
    # #     "locative"
    # #     "lock"
    # #     "logbook"
    # #     "logentries"
    #     "logger"
    # #     "logi_circle"
    # #     "london_air"
    # #     "london_underground"
    # #     "lookin"
    # #     "lovelace"
    # #     "luci"
    # #     "luftdaten"
    # #     "lupusec"
    # #     "lutron"
    # #     "lutron_caseta"
    # #     "lw12wifi"
    # #     "lyric"
    # #     "magicseaweed"
    # #     "mailgun"
    # #     "manual"
    # #     "manual_mqtt"
    # #     "map"
    # #     "marytts"
    #     "mastodon"
    #     "matrix"
    # #     "maxcube"
    # #     "mazda"
    # #     "meater"
    #     "media_extractor"
    #     "media_player"
    #     "media_source"
    # #     "mediaroom"
    # #     "melcloud"
    # #     "melissa"
    # #     "melnor"
    # #     "meraki"
    # #     "message_bird"
    # #     "met"
    # #     "met_eireann"
    # #     "meteo_france"
    # #     "meteoalarm"
    # #     "meteoclimatic"
    #     "metoffice"
    # #     "mfi"
    #     "microsoft"
    #     "microsoft_face"
    #     "microsoft_face_detect"
    #     "microsoft_face_identify"
    # #     "miflora"
    # #     "mikrotik"
    # #     "mill"
    # #     "min_max"
    # #     "minecraft_server"
    # #     "minio"
    # #     "mitemp_bt"
    #     "mjpeg"
    # #     "moat"
    #     "mobile_app"
    # #     "mochad"
    # #     "modbus"
    # #     "modem_callerid"
    # #     "modern_forms"
    # #     "moehlenhoff_alpha2"
    # #     "mold_indicator"
    # #     "monoprice"
    #     "moon"
    # #     "motion_blinds"
    #     "motioneye"
    # #     "mpd"
    # #     "mqtt"
    # #     "mqtt_eventstream"
    # #     "mqtt_json"
    # #     "mqtt_room"
    # #     "mqtt_statestream"
    # #     "msteams"
    # #     "mullvad"
    # #     "mutesync"
    # #     "mvglive"
    # #     "my"
    # #     "myq"
    # #     "mysensors"
    # #     "mystrom"
    # #     "mythicbeastsdns"
    # #     "nad"
    # #     "nam"
    # #     "namecheapdns"
    # #     "nanoleaf"
    # #     "neato"
    # #     "nederlandse_spoorwegen"
    # #     "ness_alarm"
    # #     "nest"
    # #     "netatmo"
    # #     "netdata"
    # #     "netgear"
    # #     "netgear_lte"
    # #     "netio"
    #     "network"
    # #     "neurio_energy"
    # #     "nexia"
    # #     "nextbus"
    #     "nextcloud"
    # #     "nextdns"
    # #     "nfandroidtv"
    # #     "nibe_heatpump"
    # #     "nightscout"
    # #     "niko_home_control"
    # #     "nilu"
    # #     "nina"
    # #     "nissan_leaf"
    #     "nmap_tracker"
    # #     "nmbs"
    # #     "no_ip"
    # #     "noaa_tides"
    # #     "nobo_hub"
    # #     "norway_air"
    # #     "notify"
    # #     "notify_events"
    # #     "notion"
    # #     "nsw_fuel_station"
    # #     "nsw_rural_fire_service_feed"
    # #     "nuheat"
    # #     "nuki"
    # #     "numato"
    # #     "number"
    # #     "nut"
    # #     "nws"
    # #     "nx584"
    # #     "nzbget"
    # #     "oasa_telematics"
    # #     "obihai"
    # #     "octoprint"
    #     "oem"
    # #     "ohmconnect"
    # #     "ombi"
    # #     "omnilogic"
    # #     "onboarding"
    # #     "oncue"
    # #     "ondilo_ico"
    # #     "onewire"
    # #     "onkyo"
    # #     "onvif"
    # #     "open_meteo"
    # #     "openalpr_cloud"
    # #     "openalpr_local"
    # #     "opencv"
    # #     "openerz"
    # #     "openevse"
    # #     "openexchangerates"
    # #     "opengarage"
    # #     "openhardwaremonitor"
    # #     "openhome"
    # #     "opensensemap"
    #     "opensky"
    # #     "opentherm_gw"
    # #     "openuv"
    # #     "openweathermap"
    # #     "opnsense"
    # #     "opple"
    # #     "oru"
    # #     "orvibo"
    # #     "osramlightify"
    # #     "otp"
    # #     "overkiz"
    # #     "ovo_energy"
    #     "owntracks"
    # #     "p1_monitor"
    # #     "panasonic_bluray"
    # #     "panasonic_viera"
    # #     "pandora"
    # #     "panel_custom"
    # #     "panel_iframe"
    # #     "peco"
    # #     "pencom"
    #     "persistent_notification"
    #     "person"
    # #     "philips_js"
    # #     "pi_hole"
    # #     "picnic"
    # #     "picotts"
    # #     "pilight"
    # #     "ping"
    # #     "pioneer"
    # #     "pjlink"
    # #     "plaato"
    #     "plant"
    # #     "plex"
    # #     "plugwise"
    # #     "plum_lightpad"
    # #     "pocketcasts"
    # #     "point"
    # #     "poolsense"
    # #     "powerwall"
    # #     "profiler"
    # #     "progettihwsw"
    # #     "proliphix"
    # #     "prometheus"
    # #     "prosegur"
    # #     "prowl"
    # #     "proximity"
    # #     "proxmoxve"
    # #     "proxy"
    # #     "prusalink"
    #     "ps4"
    # #     "pulseaudio_loopback"
    # #     "pure_energie"
    # #     "push"
    # #     "pushbullet"
    # #     "pushover"
    # #     "pushsafer"
    # #     "pvoutput"
    # #     "pvpc_hourly_pricing"
    # #     "pyload"
    # #     "python_script"
    #     "qbittorrent"
    # #     "qingping"
    # #     "qld_bushfire"
    # #     "qnap"
    # #     "qnap_qsw"
    #     "qrcode"
    #     "quantum_gateway"
    # #     "qvr_pro"
    # #     "qwikswitch"
    # #     "rachio"
    # #     "radarr"
    #     "radio_browser"
    # #     "radiotherm"
    # #     "rainbird"
    # #     "raincloud"
    # #     "rainforest_eagle"
    # #     "rainmachine"
    # #     "random"
    #     "raspberry_pi"
    #     "raspyrfm"
    # #     "rdw"
    # #     "recollect_waste"
    # #     "recorder"
    # #     "recswitch"
    #     "reddit"
    # #     "rejseplanen"
    # #     "remember_the_milk"
    #     "remote"
    #     "remote_rpi_gpio"
    # #     "renault"
    #     "repairs"
    # #     "repetier"
    #     "rest"
    #     "rest_command"
    # #     "rflink"
    # #     "rfxtrx"
    # #     "rhasspy"
    # #     "ridwell"
    # #     "ring"
    # #     "ripple"
    # #     "risco"
    # #     "rituals_perfume_genie"
    # #     "rmvtransport"
    # #     "rocketchat"
    # #     "roku"
    # #     "roomba"
    # #     "roon"
    # #     "route53"
    # #     "rova"
    #     "rpi_camera"
    #     "rpi_power"
    # #     "rss_feed_template"
    # #     "rtorrent"
    # #     "rtsp_to_webrtc"
    # #     "ruckus_unleashed"
    # #     "russound_rio"
    # #     "russound_rnet"
    # #     "sabnzbd"
    # #     "safe_mode"
    # #     "saj"
    #     "samsungtv"
    # #     "satel_integra"
    # #     "scene"
    # #     "schedule"
    # #     "schluter"
    #     "scrape"
    # #     "screenlogic"
    #     "script"
    # #     "scsgate"
    #     "search"
    #     "season"
    #     "select"
    # #     "sendgrid"
    # #     "sense"
    # #     "senseme"
    # #     "sensibo"
    # #     "sensor"
    # #     "sensorpro"
    # #     "sensorpush"
    # #     "sentry"
    # #     "senz"
    # #     "serial"
    # #     "serial_pm"
    # #     "sesame"
    # #     "seven_segments"
    # #     "seventeentrack"
    # #     "sharkiq"
    #     "shell_command"
    #     "shelly"
    # #     "shiftr"
    #     "shodan"
    #     "shopping_list"
    # #     "sia"
    # #     "sigfox"
    # #     "sighthound"
    # #     "signal_messenger"
    # #     "simplepush"
    # #     "simplisafe"
    # #     "simulated"
    # #     "sinch"
    # #     "siren"
    # #     "sisyphus"
    # #     "sky_hub"
    # #     "skybeacon"
    # #     "skybell"
    # #     "slack"
    # #     "sleepiq"
    # #     "slide"
    # #     "slimproto"
    # #     "sma"
    # #     "smappee"
    # #     "smart_meter_texas"
    # #     "smartthings"
    # #     "smarttub"
    # #     "smarty"
    # #     "smhi"
    # #     "sms"
    # #     "smtp"
    # #     "snapcast"
    # #     "snips"
    # #     "snmp"
    # #     "solaredge"
    # #     "solaredge_local"
    # #     "solarlog"
    # #     "solax"
    # #     "soma"
    # #     "somfy_mylink"
    # #     "sonarr"
    # #     "songpal"
    # #     "sonos"
    # #     "sony_projector"
    # #     "soundtouch"
    #     "spaceapi"
    # #     "spc"
    #     "speedtestdotnet"
    # #     "spider"
    # #     "splunk"
    #     "spotify"
    # #     "sql"
    # #     "squeezebox"
    # #     "srp_energy"
    # #     "ssdp"
    # #     "starline"
    # #     "starlingbank"
    # #     "startca"
    # #     "statistics"
    # #     "statsd"
    #     "steam_online"
    #     "steamist"
    # #     "stiebel_eltron"
    # #     "stookalert"
    # #     "stream"
    # #     "streamlabswater"
    # #     "stt"
    # #     "subaru"
    # #     "suez_water"
    #     "sun"
    # #     "supervisord"
    # #     "supla"
    # #     "surepetcare"
    # #     "swiss_hydrological_data"
    # #     "swiss_public_transport"
    # #     "swisscom"
    # #     "switch"
    # #     "switch_as_x"
    # #     "switchbee"
    # #     "switchbot"
    # #     "switcher_kis"
    # #     "switchmate"
    # #     "syncthing"
    # #     "syncthru"
    # #     "synology_chat"
    # #     "synology_dsm"
    # #     "synology_srm"
    #     "syslog"
    # #     "system_bridge"
    # #     "system_health"
    #     "system_log"
    #     "systemmonitor"
    # #     "tado"
    # #     "tag"
    #     "tailscale"
    # #     "tank_utility"
    # #     "tankerkoenig"
    # #     "tapsaff"
    # #     "tasmota"
    # #     "tautulli"
    # #     "tcp"
    # #     "ted5000"
    # #     "telegram"
    # #     "telegram_bot"
    # #     "tellduslive"
    # #     "tellstick"
    #     "telnet"
    # #     "temper"
    # #     "template"
    # #     "tensorflow"
    # #     "tesla_wall_connector"
    # #     "tfiac"
    # #     "thermobeacon"
    # #     "thermopro"
    # #     "thermoworks_smoke"
    # #     "thethingsnetwork"
    # #     "thingspeak"
    # #     "thinkingcleaner"
    # #     "thomson"
    # #     "threshold"
    # #     "tibber"
    # #     "tikteck"
    # #     "tile"
    # #     "tilt_ble"
    # #     "time_date"
    # #     "timer"
    # #     "tmb"
    # #     "tod"
    # #     "todoist"
    # #     "tolo"
    # #     "tomato"
    # #     "tomorrowio"
    # #     "toon"
    # #     "torque"
    # #     "totalconnect"
    # #     "touchline"
    #     "tplink"
    #     "tplink_lte"
    # #     "traccar"
    # #     "trace"
    # #     "tractive"
    # #     "tradfri"
    # #     "trafikverket_ferry"
    # #     "trafikverket_train"
    # #     "trafikverket_weatherstation"
    # #     "transmission"
    # #     "transport_nsw"
    # #     "travisci"
    # #     "trend"
    # #     "tts"
    # #     "tuya"
    # #     "twentemilieu"
    #     "twilio"
    #     "twilio_call"
    #     "twilio_sms"
    # #     "twinkly"
    #     "twitch"
    #     "twitter"
    # #     "ubus"
    # #     "ue_smart_radio"
    #     "uk_transport"
    # #     "ukraine_alarm"
    # #     "unifi"
    # #     "unifi_direct"
    # #     "unifiled"
    # #     "unifiprotect"
    # #     "universal"
    # #     "upb"
    # #     "upc_connect"
    # #     "upcloud"
    # #     "update"
    #     "upnp"
    #     "uptime"
    #     "uptimerobot"
    #     "usb"
    # #     "usgs_earthquakes_feed"
    # #     "utility_meter"
    #     "uvc"
    # #     "vacuum"
    # #     "vallox"
    # #     "vasttrafik"
    # #     "velbus"
    # #     "velux"
    # #     "venstar"
    # #     "vera"
    # #     "verisure"
    # #     "versasense"
    # #     "version"
    # #     "vesync"
    # #     "viaggiatreno"
    # #     "vicare"
    # #     "vilfo"
    # #     "vivotek"
    # #     "vizio"
    #     "vlc"
    #     "vlc_telnet"
    # #     "voicerss"
    # #     "volkszaehler"
    # #     "volumio"
    # #     "volvooncall"
    # #     "vulcan"
    # #     "vultr"
    # #     "w800rf32"
    #     "wake_on_lan"
    #     "wake_word"
    # #     "wallbox"
    # #     "waqi"
    # #     "water_heater"
    # #     "waterfurnace"
    # #     "watson_iot"
    # #     "watson_tts"
    # #     "watttime"
    # #     "waze_travel_time"
    #     "weather"
    # #     "webhook"
    # #     "webostv"
    #     "websocket_api"
    # #     "wemo"
    # #     "whirlpool"
    #     "whois"
    # #     "wiffi"
    # #     "wilight"
    # #     "wirelesstag"
    # #     "withings"
    # #     "wiz"
    # #     "wled"
    # #     "wolflink"
    #     "workday"
    #     "worldclock"
    # #     "worldtidesinfo"
    # #     "worxlandroid"
    # #     "ws66i"
    # #     "wsdot"
    # #     "x10"
    #     "xbox"
    # #     "xeoma"
    # #     "xiaomi"
    # #     "xiaomi_aqara"
    # #     "xiaomi_ble"
    # #     "xiaomi_miio"
    # #     "xiaomi_tv"
    #     "xmpp"
    # #     "xs1"
    # #     "yale_smart_alarm"
    # #     "yalexs_ble"
    # #     "yamaha"
    # #     "yamaha_musiccast"
    # #     "yandex_transport"
    # #     "yandextts"
    # #     "yeelight"
    # #     "yeelightsunflower"
    # #     "yi"
    # #     "yolink"
    # #     "youless"
    #     "youtube"
    # #     "zabbix"
    # #     "zamg"
    # #     "zengge"
    #     "zeroconf"
    # #     "zerproc"
    # #     "zestimate"
    # #     "zha"
    # #     "zhong_hong"
    # #     "ziggo_mediabox_xl"
    #     "zodiac"
    #     "zone"
    # #     "zoneminder"
    #    ];
    # };

    # synergy = {
    #   server = {
    #     enable = true;
    #     screenName = "sinistra";
    #   };
    # };

    #plex = {
    #  enable = true;
    #  package = pkgs.plex;
    #  openFirewall = true;
    #};

    # perm issues
    #nextcloud = {
    #  enable = true;
    #  package = pkgs.nextcloud24;
    #  https = true;
    #  hostname = "nextcloud.${domain}";
    #  webfinger = true;
    #  config = {
    #    dbtype = "pgsql";
    #    dbhost = "localhost";
    #    dbname = "nextcloud";
    #    dbuser = "nextcloud";
    #    dbpassFile = "${privateDir}/nextcloud/dbpass";
    #    adminuser = "root";
    #    adminpassFile = "${privateDir}/nextcloud/adminpass";
    #    defaultPhoneRegion = "GB";
    #    overwriteProtocol = "https";
    #  };
    #  autoUpdateApps = {
    #    enable = true;
    #  };
    #};

    # rabbitmq = {
    #   enable = true;
    #   configItems = {
    #     default_user = "rabbitmq";
    #     default_pass = builtins.readFile "${privateDir}/rabbitmq/password";
    #   };
    # };

    postgresql = let
      nextcloudPassword = builtins.readFile "${privateDir}/nextcloud/dbpass";
      msfPassword = builtins.readFile "${privateDir}/msf/dbpass";
      ttrssPassword = builtins.readFile "${privateDir}/tt-rss/dbpass";
      appBuilderPassword = builtins.readFile "${privateDir}/app-builder/dbpass";
      jobfinderPassword = builtins.readFile "${privateDir}/jobfinder/dbpass";
      onlyofficeDBPassword = builtins.readFile "${privateDir}/onlyoffice/dbpass";
      szuruPassword = builtins.readFile "${privateDir}/szuru/dbpass";
    in {
      enable = true;
      package = pkgs.postgresql_18;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
      '';
      extensions = ps: with ps; [ pgjwt pgsql-http ];
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE msf WITH LOGIN PASSWORD '${msfPassword}' CREATEDB;
        CREATE DATABASE msf;
        GRANT ALL PRIVILEGES ON DATABASE msf TO msf;

        CREATE ROLE nextcloud WITH LOGIN PASSWORD '${nextcloudPassword}' CREATEDB;
        CREATE DATABASE nextcloud;
        GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;

        CREATE ROLE tt_rss WITH LOGIN PASSWORD '${ttrssPassword}' CREATEDB;
        CREATE DATABASE tt_rss;
        GRANT ALL PRIVILEGES ON DATABASE tt_rss TO tt_rss;

        CREATE ROLE szurubooru WITH LOGIN PASSWORD '${szuruPassword}' CREATEDB;
        CREATE DATABASE szuru;
        GRANT ALL PRIVILEGES ON DATABASE szuru TO szurubooru;
        GRANT CREATE, USAGE ON DATABASE szuru TO szurubooru;

        CREATE ROLE jobfinder WITH LOGIN PASSWORD '${jobfinderPassword}' CREATEDB CREATEROLE;
        CREATE DATABASE jobfinder;
        GRANT ALL PRIVILEGES ON DATABASE jobfinder TO jobfinder;
      '';

      # -- create schema app_builder;
      # -- create role web_anon nologin;
      # -- grant usage on schema app_builder to web_anon;
      # -- create table app_builder.apps (id serial primary key, name text);
      # -- grant select on app_builder.apps to web_anon;
      # -- create role authenticator noinherit login password '${appBuilderPassword}';
      # -- grant web_anon to authenticator; # 
      # -- create schema jobfinder;
      # -- create role web_anon nologin;
      # -- grant usage on schema jobfinder to web_anon;
      # -- create role authenticator noinherit login password '${jobfinderPassword}';
      # -- grant web_anon to authenticator;
      # create role onlyoffice with login password '${onlyofficeDBPassword}' CREATEDB;
      # CREATE DATABASE onlyoffice;
      # GRANT ALL PRIVILEGES ON DATABASE onlyoffice TO onlyoffice;
    };

    udisks2.enable = true;

    #usbguard = {
    #  enable = true;
    #  rules = builtins.readFile ./conf/usbguard.rules;
    #};

    # miredo.enable = true;

    pulseaudio.enable = false;

    pipewire = if isDesktop then {
      enable = true;
      jack = {
        enable = true;
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    } else {};

    # postfix = {
    #   enable = true;
    #   domain = "mail.${domain}";
    #   rootAlias = username;
    #   config = {
    #     smtpd_use_tls = true;
    #     smtpd_tls_key_file = "/var/lib/acme/${hostname}.home.${domain}/key.pem";
    #     smtpd_tls_cert_file = "/var/lib/acme/${hostname}.home.${domain}/cert.pem";
    #     smtpd_tls_CAfile = "/var/lib/acme/${hostname}.home.${domain}/chain.pem";
    #     smtpd_tls_loglevel = "3";
    #     smtpd_tls_received_header = true;
    #     smtpd_tls_session_cache_timeout = "3600s";
    #   };
    #   # [smtp.gmail.com]:587    username@gmail.com:password -> sasl_passwd
    #   config = {
    #     smtp_sasl_auth_enable = true;
    #     smtp_sasl_security_options = "";
    #     # postmap this! # TODO permissions
    #     smtp_sasl_password_maps = "hash:${privateDir}/sasl_passwd";
    #     # either these 3:
    #     smtp_tls_policy_maps = "hash:${privateDir}/tls_policy";
  # # 
    #     
    #     sender_canonical_maps = "regexp:${privateDir}/sender_canonical_maps";
    #     # sender_canonical_classes = "envelope_sender, header_sender";
    #     smtp_header_checks = "regexp:${privateDir}/header_check";
    #     
    #     # or this global thing
    #     # smtp_generic_maps = hash:/etc/postfix/generic
    #     # same format as virtual
    #   };
    #   relayHost = "smtp-mail.outlook.com";
    #   relayPort = 587;
    #   relayDomains = [
    #     # domain
    #     # "hotmail.co.uk"
    #   ];
    #   setSendmail = true;
    #   # virtual = ''
    #   #   ${username}@${hostname} ${username}@${domain}
    #   #   ${username} ${username}@${domain}
    #   #   root ${username}@${domain}
    #   #   cron ${username}@${domain}
    #   #   @${hostname} ${username}@${domain}
    #   #   @${hostname}.${hostname}.${domain} ${username}@${domain}
    #   #   @${hostname}.${domain} ${username}@${domain}
    #   #   MAILER-DAEMON@${hostname}.${hostname}.${domain} ${username}@${domain}
    #   # '';
    # };

    printing.enable = isDesktop;

    # openssh = {
    #   enable = true;
    #   banner = "Connection established to ${hostname}. Unauthorised connections are logged.\n";
    #   openFirewall = true;
    #   listenAddresses = [
    #     {
    #       addr = internalIPv4;
    #       port = 2345;
    #     }
    #     # {
    #     #   addr = "[${localIPv6}]";
    #     #   port = 2345;
    #     # }
    #     # {
    #     #   addr = "::1";
    #     #   port = 2345;
    #     # }
    #     # {
    #     #   addr = "127.0.0.1";
    #     #   port = 2345;
    #     # }
    #   ];
    # };

    ulogd = {
      enable = true;
      settings = {
        emu1 = {
          file = "/var/log/ulogd_pkts.log";
          sync = 1;
        };
        global = {
          stack = [
            "log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU"
            "log1:NFLOG,base1:BASE,pcap1:PCAP"
          ];
        };
        log1 = {
          group = 2;
        };
        pcap1 = {
          file = "/var/log/ulogd.pcap";
          sync = 1;
        };
      };
    };

    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      sslKey = "/var/lib/acme/${hostname}.home.${domain}/key.pem";
      sslCert = "/var/lib/acme/${hostname}.home.${domain}/cert.pem";
      audio = {
        enable = true;
      };
      extraConfDirCommands = ''
        
      '';
    };

    avahi = if isDesktop then { # dbus_bus_request_name(): Request to own name refused by policy
      enable = true;
      # wideArea = true; # CVE-2024-52615
      ipv6 = true;
      nssmdns4 = true;
      nssmdns6 = true;
      # domainName = domain
      # domainName = "local";
      # domainName = "home.arpa";
      openFirewall = true;
      publish = {
        enable = true;
        # browseDomains = [ domain ];
        hinfo = true;
        domain = true;
        # addresses = true;
        userServices = true;
        workstation = true;
      };
    } else {};

    fail2ban.enable = true;

    # ntopng.enable = true;

    # mozillavpn.enable = isDesktop;

    joycond.enable = isDesktop;

    syslogd.enableNetworkInput = true;

    syslog-ng = let
      discordSyslogEndpoint = builtins.readFile "${privateDir}/discord/endpoints/syslog";
    in {
      enable = true;
      extraConfig = ''
        source s_net {
          tcp(port(514) flags(syslog-protocol));
        };
        destination d_http {
            http(
                url("${discordSyslogEndpoint}")
                method("POST")
                user-agent("syslog-ng User Agent")
                headers("Content-Type: application/json")
                body('{"username": "test", "content": "''${ISODATE} ''${MESSAGE}"}')
            );
        };

        log {
            source(s_net);
            destination(d_http);
        };
      '';
    };

    # journald.forwardToSyslog = true;

    # clamav = {
    #   scanner = {
    #     enable = true;
    #   };
    #   updater = {
    #     enable = true;
    #     interval = "*/30 * * * *";
    #     frequency = 48;
    #     settings = {
    #       SafeBrowsing = true;
    #     };
    #   };
    #   # fangfrisch = {
    #   #   enable = true;
    #   # };
    #   daemon = {
    #     enable = true;
    #     settings = {
    #     };
    #   };
    # };
  };
}