{ lib, domain, hostname, homeDirectory, isDesktop, pkgs, ... }:
with builtins;
with lib;
let
  telnetServers = import ./servers/telnet.nix;
  allowTelnet = ip: "iptables-nft -A OUTPUT -p tcp --dport 23 -d ${ip} -j ACCEPT";
in {
  networking = {
    hostName = hostname;
    inherit domain;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    nameservers = [
      # if using DoH/DoT proxy
      # "127.0.0.1" "::1"
      # opennic, giving http://grep.geek etc
      # "194.36.144.87" "94.247.43.254" "2a03:4000:4d:c92:88c0:96ff:fec6:b9d" "2a00:f826:8:1::254"
      # also opennic
      # "95.217.229.211" "165.22.224.164" "2a01:4f9:4b:39ea::301" "2604:a880:cad:d0::d9a:f001"
      # adguard
      "94.140.14.14" "94.140.15.15" "2a10:50c0::ad1:ff" "2a10:50c0::ad2:ff"
      # quad9
      # "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9"
    ];

    # resolvconf.enable = false;

    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-fortisslvpn
        networkmanager-iodine
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-sstp
        networkmanager-strongswan
        networkmanager-vpnc
      ];
      # packages =
      #    dns = "
      insertNameservers = [
        # doesn't work when I connect to ipv4 only hotspots
        # "2a01:239:2fd:b700::1"
        # "2001:4ba0:cafe:3d2::1"
        # "2a01:238:4231:5200::1"
        # "2a03:94e0:1804::1"
        # "217.160.70.42"
        # "213.202.211.221"
        # "81.169.136.222"
        # "185.181.61.24"
      ];
      # ensureProfiles = {
      #   profiles = {
      #       "${wifiNetwork}" = {
      #         connection = {
      #           id = "${wifiNetwork}";
      #           uuid = "85476ebf-97b1-4089-860c-ad36f28966b8";
      #           permissions = "";
      #           type = "wifi";
      #         };
      #         ipv4 = {
      #           dns-search = "";
      #           may-fail = false;
      #           method = "auto";
      #           dns = "dns=213.202.211.221;81.169.136.222;185.181.61.24;";
      #         };
      #         ipv6 = {
      #           addr-gen-mode = "stable-privacy";
      #           ip6-privacy = false;
      #           may-fail = false;
      #           dns-search = "";
      #           method = "auto";
      #           dns = "2001:4ba0:cafe:3d2::1;2a01:238:4231:5200::1;2a03:94e0:1804::1;";
      #         };
      #         wifi = {
      #           mode = "infrastructure";
      #           ssid = "${wifiNetwork}";
      #         };
      #         wifi-security = {
      #           auth-alg = "open";
      #           key-mgmt = "sae";
      #           psk = "${wifiPassword}";
      #         };
      #       };
      #       "${wifiNetwork} (2.4GHz only)" = {
      #         connection = {
      #           id = "${wifiNetwork}";
      #           uuid = "a825f5fd-1202-4674-a17d-68d86c6a7865";
      #           permissions = "user:ember:;";
      #           type = "wifi";
      #         };
      #         ipv4 = {
      #           may-fail = false;
      #           dns-search = "";
      #           method = "auto";
      #           dns = "dns=213.202.211.221;81.169.136.222;185.181.61.24;";
      #         };
      #         ipv6 = {
      #           addr-gen-mode = "stable-privacy";
      #           ip6-privacy = false;
      #           may-fail = false;
      #           dns-search = "";
      #           ignore-auto-dns = true;
      #           method = "auto";
      #           dns = "2001:4ba0:cafe:3d2::1;2a01:238:4231:5200::1;2a03:94e0:1804::1;";
      #         };
      #         wifi = {
      #           bssid = "${bssid24}";
      #           mode = "infrastructure";
      #           ssid = "${wifiNetwork}";
      #         };
      #         wifi-security = {
      #           auth-alg = "open";
      #           key-mgmt = "sae";
      #           psk = "${wifiPassword}";
      #         };
      #       };
      #       "${wifiNetwork} (5GHz only)" = {
      #         connection = {
      #           id = "${wifiNetwork}";
      #           uuid = "448eeece-905a-4a6c-b1ca-d57a17db0c26";
      #           permissions = "user:ember:;";
      #           type = "wifi";
      #         };
      #         ipv4 = {
      #           dns-search = "";
      #           method = "auto";
      #           may-fail = false;
      #           dns = "dns=213.202.211.221;81.169.136.222;185.181.61.24;";
      #         };
      #         ipv6 = {
      #           addr-gen-mode = "stable-privacy";
      #           ip6-privacy = false;
      #           may-fail = false;
      #           dns-search = "";
      #           ignore-auto-dns = true;
      #           method = "auto";
      #           dns = "2001:4ba0:cafe:3d2::1;2a01:238:4231:5200::1;2a03:94e0:1804::1;";
      #         };
      #         wifi = {
      #           bssid = "${bssid5}";
      #           mode = "infrastructure";
      #           ssid = "${wifiNetwork}";
      #         };
      #         wifi-security = {
      #           auth-alg = "open";
      #           key-mgmt = "sae";
      #           psk = "${wifiPassword}";
      #         };
      #       };
      #       "${wifiNetwork} (default DNS)" = {
      #         connection = {
      #           id = "${wifiNetwork}";
      #           uuid = "d6f1a9f3-c007-4008-9641-053d8f6dcf33";
      #           permissions = "user:ember:;";
      #           type = "wifi";
      #         };
      #         ipv4 = {
      #           dns-search = "";
      #           method = "auto";
      #           may-fail = false;
      #         };
      #         ipv6 = {
      #           addr-gen-mode = "stable-privacy";
      #           ip6-privacy = false;
      #           may-fail = false;
      #           dns-search = "";
      #           ignore-auto-dns = true;
      #           method = "auto";
      #         };
      #         wifi = {
      #           mode = "infrastructure";
      #           ssid = "${wifiNetwork}";
      #         };
      #         wifi-security = {
      #           auth-alg = "open";
      #           key-mgmt = "sae";
      #           psk = "${wifiPassword}";
      #         };
      #       };
      #       "${wifiNetwork} (IPv6 only)" = {
      #         connection = {
      #           id = "${wifiNetwork}";
      #           uuid = "85476ebf-97b1-4089-860c-ad36f28966b8";
      #           permissions = "";
      #           type = "wifi";
      #         };
      #         ipv4 = {
      #           dns-search = "";
      #           may-fail = false;
      #           method = "auto";
      #           dns = "dns=213.202.211.221;81.169.136.222;185.181.61.24;";
      #         };
      #         ipv6 = {
      #           method = "disabled";
      #         };
      #         wifi = {
      #           mode = "infrastructure";
      #           ssid = "${wifiNetwork}";
      #         };
      #         wifi-security = {
      #           auth-alg = "open";
      #           key-mgmt = "sae";
      #           psk = "${wifiPassword}";
      #         };
      #       };
      #   }
      # }
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    # interfaces.enp0s3.useDHCP = true;

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      # Or disable the firewall altogether.
      # enable = false;
      enable = true;
      # allowedTCPPorts = [ 22 80 443 ];
      # allowedUDPPorts = [];
      # allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      # allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

      pingLimit = "--limit 1/minute --limit-burst 5";
      checkReversePath = true;
      logReversePathDrops = true;
      logRefusedConnections = true;
      # TODO to nftables
      extraCommands = ''
        export HOME_DIRECTORY=${homeDirectory}
        # export IP= # globalipv6
        # export NET6=$(/run/current-system/sw/bin/route -n6 | grep "/64" | grep ^2 | cut -d ' ' -f 1)
        export AMPR_IP4=44.63.0.51/32
        export BCAST4=192.168.1.255
        export GATEWAY4=192.168.1.1 # or 10.0.0.1
        export NET4=192.168.0.0/23
        export NET6=fd6c:5095:66e8::/56
        ''
        + (if isDesktop then
          builtins.readFile "${homeDirectory}/code/mine/nix/system/common/conf/iptables-desktop-home-permissive.sh" else
          builtins.readFile "${homeDirectory}/code/mine/nix/system/common/conf/iptables-server.sh"
        )
        + "\n"
        + (lib.strings.concatStringsSep "\n" (map allowTelnet (attrValues telnetServers)));
      # Allow private IP ranges
      # extraCommands = ''
      # '';
      # iptables-nft -A INPUT -p tcp -s 10.0.0.0/8 -j ACCEPT
      # iptables-nft -A INPUT -p tcp -s 172.17.0.0/12 -j ACCEPT
      # iptables-nft -A INPUT -p tcp -s 192.168.0.0/16 -j ACCEPT
    };

    hosts = {
      # "192.168.1.254" = [
      #   "dsldevice.lan"
      # ];
      # "fe80::1" = [
      #   "dsldevice.lan"
      # ];
      "127.0.0.1" = [
        "${hostname}.home.${domain}"
        "dev.${domain}"
        "dev.jolharg.com"
        "dev.blog.jolharg.com"
        "dev.madhackerreviews.com"
        "dev.m0ori.com"
        "dev.blog.m0ori.com"
        "dev.blog.${domain}"
        "dev.jobfinder.jolharg.com"
        "api.dev.jobfinder.jolharg.com"
        "jobfinder.jolharg.com"
        "api.jobfinder.jolharg.com"
        "news.${domain}"
        "grocy.${domain}"
        "degenerate.tsumikimikan.com"
        "dandart.geek"
      ];
      "::1" = [
        "${hostname}.home.${domain}"
        "dev.${domain}"
        "dev.jolharg.com"
        "dev.blog.jolharg.com"
        "dev.madhackerreviews.com"
        "dev.m0ori.com"
        "dev.blog.m0ori.com"
        "dev.blog.${domain}"
        "dev.jobfinder.jolharg.com"
        "api.dev.jobfinder.jolharg.com"
        "jobfinder.jolharg.com"
        "api.jobfinder.jolharg.com"
        "news.${domain}"
        "grocy.${domain}"
        "degenerate.tsumikimikan.com"
        "dandart.geek"
      ];
    };
    extraHosts = ''
      127.0.0.1      ${hostname}.home.${domain}
      ::1            ${hostname}.home.${domain}
    '';
  };
}