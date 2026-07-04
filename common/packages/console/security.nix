pkgs:
with pkgs; [
    aircrack-ng
    airgeddon
    binwalk # python issues
    # chkrootkit # has been removed as it is unmaintained and archived upstream and didn't even work on NixOS
    gpgme
    hexedit
    john
    lynis
    masscan
    metasploit # failed
    nmap
    openssl # the CLI client
    # ossec-agent - not yet integrated into systemd
    # ossec-server - not yet integrated into systemd
    sslstrip
    # rkhunter - not yet available
    sshuttle
    # tcpdump # handled
    thc-hydra
    thc-secure-delete
    torsocks
    # tripwire - not yet available - unsure if any point?
    wifite2
]