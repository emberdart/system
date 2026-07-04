{ pkgs, lib, ...}:
{
  boot = {
    kernel.sysctl = {
      # all magic sysrq keys
      "kernel.sysrq" = 1;
      # Fix some apps, see bug https://github.com/NixOS/nixpkgs/issues/110468
      # Specifically needed for hardened kernels
      "kernel.unprivileged_userns_clone" = 1;
      # try to use zram first
      # https://wiki.archlinux.org/title/Zram
      # "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    consoleLogLevel = 3;

    # linuxKernel.packages.linux_rt_5_10 = 5.10.140

    # linuxKernel.packages.linux_hardened = 5.15.67

    # https://xanmod.org/
    # linuxKernel.packages.linux_xanmod_latest = 5.18.11

    # linuxKernel.packages.linux_5_19 = 5.19.9

    # https://liquorix.net/
    # linuxKernel.packages.linux_lqx = 5.19.10 # same as zen but less aggressive release schedule

    # https://github.com/zen-kernel/zen-kernel
    # linuxKernel.packages.linux_zen = 5.19.10

    kernelPackages = pkgs.linuxPackages_latest;

    # crashy wifi?
    # https://bugzilla.kernel.org/show_bug.cgi?id=215391
    extraModprobeConfig = ''
      options mt7921e disable_aspm=1
    '';

    # no longer needs preinstalling
    lanzaboote = {
      enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      autoGenerateKeys.enable = true;
      allowUnsigned = true;
      pkiBundle = "/var/lib/sbctl";
    };

    loader.systemd-boot.enable = lib.mkForce false;
    # https://nixos.wiki/wiki/Linux_kernel
    # kernelPatches = [
    #   {
    #     name = "Amateur Radio support";
    #     patch = null;
    #     # TODO pick a cached version / remove most unneccessaries
    #     extraConfig = ''
    #             HAMRADIO y
  # 
    #             #
    #             # Packet Radio protocols
    #             #
    #             AX25 m
    #             AX25_DAMA_SLAVE y
    #             NETROM m
    #             ROSE m
  # 
    #             #
    #             # AX.25 network device drivers
    #             #
    #             MKISS m
    #             6PACK m
    #             BPQETHER m
    #             BAYCOM_SER_FDX m
    #             BAYCOM_SER_HDX m
    #             YAM m
    #             # end of AX.25 network device drivers
    #     '';
    #   }
    #   # {
    #   #   name = "Realtime support";
    #   #   patch = null;
    #   #   extraConfig = ''
    #   #           # PREEMPT_BUILT n
    #   #           PREEMPT_VOLUNTARY n
    #   #           PREEMPT_RT y
    #   #           # PREEMPT_DYNAMIC n
    #   #   '';
    #   # }
    # ];

    # kernelParams = [
    #   "intel_iommu=on"
    #   "kvm.ignore_msrs=1"
    # ];

    #kernelPatches = [
    #  {
    #    name = "generic switch pro controller support";
    #    patch = builtins.fetchurl "https://github.com/DanielOgorchock/linux/files/9727518/generic-pro-controller.log";
    #  }
    #];

    plymouth = {
      enable = true;
      theme = "breeze";
      # theme = "spinfinity";
      # logo = pkgs.fetchurl {
      #   url = "https://nixos.org/logo/nixos-hires.png";
      #   sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
      # };
    };

    tmp = {
      # useTmpfs = true; # temporarily off
      # tmpfsSize = "50%";
      cleanOnBoot = true; # unless it's tmpfs in which case who cares
    };

    binfmt = {
      addEmulatedSystemsToNixSandbox = true;
      preferStaticEmulators = true;
      # If you want anything for this built by nixos, you have to use --argstr system X
      emulatedSystems = [
        # "i686-linux" # ehhh do we need this anymore i doubt it
        "aarch64-linux" # mwuhahahaha - should allow cross compilation to be a bit easier...
        "riscv64-linux" # even more mwuhahahaha
        # "x86_64-linux" # duplication is pointless...
        "x86_64-windows" # who's that :p
        "wasm32-wasi"
        "wasm64-wasi"
      ];
    };
  };
}