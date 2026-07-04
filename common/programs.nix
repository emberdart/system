{ pkgs, isDesktop, ...}:
{
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    ghidra = {
      enable = isDesktop;
      gdb = true;
    };

    steam = if builtins.currentSystem == "x86_64-linux" && isDesktop then {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
      protontricks = {
        enable = true;
      };
    } else {};

    dconf.enable = true;

    # mkSystemd missing???
    # atop = {
    #   enable = true;
    #   # netatop = {
    #   #   enable = true;
    #   # };
    #   setuidWrapper = {
    #     enable = true;
    #   };
    # };

    command-not-found.enable = false;

    wireshark.enable = true; # still need the package though!!

    iftop.enable = true;

    iotop.enable = true;

    fuse.userAllowOther = true;

    partition-manager.enable = isDesktop;

    # Nooooooooo!
    # soundmodem.enable = isDesktop;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # nethoscope.enable = true;

    nix-index = {
      enable = true;
    };

    # required for a non-hacked doctl sls
    nix-ld = {
      enable = true;
      # Sets up all the libraries to load
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        zlib
        nss
        openssl
        curl
        expat
      ];
    };

    obs-studio = {
      enable = true;
    };

    # xppen.enable = true;

    # big
    # darling.enable = true;

    # zsh = {
    #   enable = true;
    #   ohMyZsh = {
    #     enable = true;
    #     plugins = [ "git" "man" ];
    #     # theme = "agnoster";
    #   };
    # };

    tcpdump = {
      enable = true;
    };

    zmap = {
      enable = true;
    };

    firefox = {
      enable = true;
      # error: attribute 'nameValuePair' missing
      # languagePacks = [ "en-GB" ];
      preferences = {
        "browser.contentblocking.category" = "strict";
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.rights.3.shown" = true;
        # "network.trr.mode" = 3;
        # "network.trr.uri" = "https://doh.kekew.info/dns-query";
        # these preferences not allowed for stability reasons?
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };

    gamemode = {
      enable = true;
      enableRenice = true;
    };

    # basically be steamos WM
    gamescope = {
      enable = true;
    };

    htop = {
      enable = true;
      settings = {};
    };

    kdeconnect = {
      enable = true; # auto open firewall
    };

    localsend = {
      enable = true;
    };

    # neovim = {
    #   enable = true;
    # };

    screen = {
      enable = true;
      screenrc = ''
      '';
    };

    sedutil = {
      enable = true;
    };

    traceroute = {
      enable = true;
    };

    virt-manager = {
      enable = true;
    };

    weylus = {
      enable = true;
      openFirewall = true;
      users = [ "ember" ];
    };


  # Traceback (most recent call last):
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/msetup.py", line 249, in _generate
  #     intr.run()
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreter/interpreter.py", line 3051, in run
  #     super().run()
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreterbase/interpreterbase.py", line 178, in run
  #     self.evaluate_codeblock(self.ast, start=1)
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreterbase/interpreterbase.py", line 203, in evaluate_codeblock
  #     raise e
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreterbase/interpreterbase.py", line 195, in evaluate_codeblock
  #     self.evaluate_statement(cur)
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreterbase/interpreterbase.py", line 209, in evaluate_statement
  #     return self.function_call(cur)
  #            ^^^^^^^^^^^^^^^^^^^^^^^
  #   File "/nix/store/n71x3269wc0h52as5pv2rmym4rymm4ay-meson-1.8.2/lib/python3.11/site-packages/mesonbuild/interpreterbase/interpreterbase.py", line 536, in function_call
  #     res = func(node, func_args, kwargs)
  # error: builder for '/nix/store/08pkhv9fnzyls1rmiq0gw9n0n2qr776a-security-wrapper-wavemon-x86_64-unknown-linux-musl.drv' failed with exit code 1
    # wavemon = {
    #   enable = true;
    # };

    xastir = {
      enable = true;
    };
  };
}
