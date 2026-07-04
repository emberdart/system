{ config, lib, pkgs, modulesPath, ... }:
let
  netboot = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    modules = [
      (pkgs.path + "/nixos/modules/installer/netboot/netboot.nix")
      {
        # you will want to add options here to support your filesystem
        # and also maybe ssh to let you in
        # boot.supportedFilesystems = [ "zfs" ];

        boot = {
          initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "uas" "usb_storage" "sd_mod" ];
            kernelModules = [ ];
          };
          kernelModules = [ "kvm-intel" ];
        };
        system.stateVersion = "25.11";

      #   networking.networkmanager = {
      #     enable = true;
      #     ensureProfiles = {
      #       profiles = {
      #           "${wifiNetwork}" = {
      #             connection = {
      #               id = "${wifiNetwork}";
      #               uuid = "85476ebf-97b1-4089-860c-ad36f28966b8";
      #               permissions = "";
      #               type = "wifi";
      #             };
      #             ipv4 = {
      #               dns-search = "";
      #               may-fail = false;
      #               method = "auto";
      #               dns = "dns=213.202.211.221;81.169.136.222;185.181.61.24;";
      #             };
      #             ipv6 = {
      #               addr-gen-mode = "stable-privacy";
      #               ip6-privacy = false;
      #               may-fail = false;
      #               dns-search = "";
      #               method = "auto";
      #               dns = "2001:4ba0:cafe:3d2::1;2a01:238:4231:5200::1;2a03:94e0:1804::1;";
      #             };
      #             wifi = {
      #               mode = "infrastructure";
      #               ssid = "${wifiNetwork}";
      #             };
      #             wifi-security = {
      #               auth-alg = "open";
      #               key-mgmt = "sae";
      #               psk = "${wifiPassword}";
      #             };
      #           };
      #       };
      #     };
      # };
      }
    ];
  };
  
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      systemd = {
        enable = true; # default? but too big!
      };
      verbose = false;
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "uas" "sd_mod" "aesni_intel" "cryptd" ];
      kernelModules = [ ];
      luks = {
        devices = {
          "cryptroot" = {
            device = "/dev/disk/by-uuid/e4bbfabb-1c83-420b-ba43-f008bd7c2513";
          };
        };
      };
    };

    kernelModules = [ "kvm-intel" "ax25" "mkiss" "netrom" ];

    kernelParams = [
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    
    extraModulePackages = [ ];
    
    loader = {
      systemd-boot = {
        enable = true;
        # xbootldrMountPoint = "/boot";
        extraEntries = {
          "nixos-installer.conf" = ''
            title NixOS Installer
            version 25.05
            linux rescue-kernel 
            initrd rescue-initrd
            options init=${netboot.config.system.build.toplevel}/init ${toString netboot.config.boot.kernelParams} i915.enable_gvt=1
          '';
        };
        extraFiles = {
          "rescue-kernel" = "${netboot.config.system.build.kernel}/bzImage";
          "rescue-initrd" = "${netboot.config.system.build.netbootRamdisk}/initrd";
        };
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
  };

  # fileSystems."/" = lib.mkDefault
  #   { device = "/dev/disk/by-uuid/1778de2b-8859-4988-9fed-cbd53b8fb7cf";
  #     fsType = "ext4";
  #     options = [ "noatime" ];
  #   };

  # fileSystems."/" = {
  #   device = "tmpfs";
  #   fsType = "tmpfs";
  #   options = [
  #     "size=16G"
  #   ];
  # };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/E284-22EC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    # "/boot" = {
    #   device = "/dev/disk/by-uuid/8D81-08D8";
    #   fsType = "vfat";
    #   options = [ "fmask=0022" "dmask=0022" ];
    # };
  };

  # real swap for hibernate, if it'll ever work
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
    }
  ];
  
  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  #   # numDevices = 1; # Using ZRAM devices as general purpose ephemeral block devices is no longer supported
  #   swapDevices = 1;
  #   memoryPercent = 50;
  # };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      sync.enable = true;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];

  # environment.persistence."/persist" = {
  #   hideMounts = true;
  #   directories = [
  #     "/etc/ax25"
  #     "/etc/ssh"
  #     "/etc/NetworkManager"
  #     "/etc/secureboot"
  #     "/var/lib"
  #     "/root/.cache/nix" # for when rebuilding the system
  #     "/nix"
  #     "/tmp" # temporarily on
  #   ];
  #   files = [
  #     "/etc/machine-id"
  #     # "/root/.nix-channels" # keeps dying
  #   ];
  #   users = {
  #     ember = { # todo imports = [ /path/to/impermanence/home-manager.nix ]; & move to home.persistence."/persist/home/ember" on flag
  #       directories = [
  #         "code"
  #         "Desktop"
  #         "Documents"
  #         "Downloads"
  #         "from"
  #         "games"
  #         "Music"
  #         "Pictures"
  #         "qsstv"
  #         "radioimages"
  #         "Templates" # Really? I don't even use that. But should I? There's no harm...
  #         "Videos"
  #         "VMs"
  #         ".android"
  #         ".armagetronad"
  #         ".cache/nix" # Stop having to keep redownloading tarballs and search indices
  #         ".cache/spotify" # Keep me logged in
  #         ".config/autostart"
  #         ".config/cachix"
  #         ".config/calibre"
  #         ".config/Code/Backups" # Unsaved open files and workspaces
  #         ".config/discord"
  #         ".config/doctl"
  #         ".config/dolphin-emu"
  #         ".config/Element"
  #         ".config/gh"
  #         ".config/Gpredict"
  #         ".config/htop"
  #         ".config/Insomnia"
  #         ".config/kdeconnect"
  #         ".config/Microsoft/Microsoft Teams"
  #         ".config/nethack"
  #         ".config/Nextcloud"
  #         ".config/ON4QZ" # qsstv
  #         ".config/PCSX2"
  #         # ".config/Postman"
  #         ".config/rclone"
  #         ".config/spotify" # cache as well?
  #         ".config/Slack"
  #         # ".config/VirtualBox" # TODO move?
  #         ".dosbox"
  #         ".fldigi"
  #         ".flrig"
  #         ".frozen-bubble"
  #         ".ghc"
  #         { directory = ".gnupg"; mode = "0700"; }
  #         ".googleearth"
  #         # ".kde"
  #         ".lgames"
  #         ".local/share/Baba_Is_You"
  #         ".local/share/citra-emu"
  #         ".local/share/DBeaverData"
  #         ".local/share/direnv"
  #         ".local/share/dolphin-emu"
  #         ".local/share/ktorrent"
  #         ".local/share/kwalletd"
  #         ".local/share/networkmanagement"
  #         ".local/share/Steam"
  #         ".local/share/WSJT-X"
  #         ".mozilla"
  #         # ".ngrok2"
  #         ".pcsxr"
  #         ".quakespasm"
  #         ".serverless"
  #         { directory = ".ssh"; mode = "0700"; }
  #         ".steam" # TODO copy/link, don't mount
  #         ".thunderbird"
  #         ".tor project"
  #         # ".vagrant.d" # TODO relocate
  #         ".vkquake"
  #         ".wine"
  #         ".xastir"
  #         # ".yq2"
  #       ];
  #       files = [
  #         ".bash_history"
  #         ".config/Code/storage.json" # Open files and workspaces
  #         ".config/Code/User/globalStorage/state.vscdb" # Current state
  #         ".config/dolphinrc"
  #         ".config/kdeglobals"
  #         ".config/ktorrentrc"
  #         ".config/mimeapps.list"
  #         ".config/plasma-org.kde.plasma.desktop-appletsrc"
  #         ".config/plasmarc"
  #         ".config/plasmashellrc"
  #         ".config/powerdevilrc"
  #         ".config/powermanagementprofilesrc"
  #         ".config/WSJT-X.ini"
  #         ".local/share/user-places.xbel"
  #         ".nix-channels"
  #         ".serverlessrc"
  #         "direwolf.conf"
  #       ];
  #     };
  #     raven = {
  #       directories = [
  #         "."
  #       ];
  #     };
  #   };
  # };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
