pkgs:
with pkgs; [
    autossh
    # azure-cli # TODO split? # broken
    bind # host, nslookup etc
    # cyrus_sasl
    # cyrus-sasl-xoauth2
    # docker-proxy
    doctl # run doctl auth init before use
    gping
    hans
    iodine
    irssi
    mailutils
    net-tools
    nixops_unstable_full
    openvpn
    # postgrest
    # protonvpn-cli
    proton-vpn
    # python314Packages.mitmproxy # fails to build in python3.14-msgspec
    # msgspec/_core.c:2148:7: error: ‘_Py_IMMORTAL_REFCNT’ undeclared here (not in a function)
    # 2148 |     { _Py_IMMORTAL_REFCNT },
    # python314Packages.protonvpn-nm-lib # fails to build
    # ngrok
    # proxytunnel # insecure openssl
    slirp4netns
    # ? wireguard-go
    # ? wireguard-tools
    # ? wireguard-ui
]