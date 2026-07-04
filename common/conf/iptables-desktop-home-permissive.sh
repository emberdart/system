#!/bin/sh
set -euo pipefail
trap pwd ERR

# This script gets dumped into the system one instead of being called!
HERE=$HOME_DIRECTORY/code/mine/nix/system/common/conf
source $HERE/common.sh

$IP4T -F
$IP6T -F

## INPUT
$IP4T -P INPUT DROP
$IP6T -P INPUT DROP

# SSH in
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 --dport 2345 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 --dport 2345 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA --dport 2345 -j ACCEPT

# Web in
$IP4T -A INPUT -p tcp --dport 80 -j ACCEPT # Might as well for acme
$IP6T -A INPUT -p tcp --dport 80 -j ACCEPT # Might as well for acme
$IP4T -A INPUT -p tcp --dport 443 -j ACCEPT
$IP4T -A INPUT -p udp --dport 443 -j ACCEPT # quic
$IP6T -A INPUT -p tcp --dport 443 -j ACCEPT
$IP6T -A INPUT -p udp --dport 443 -j ACCEPT # quic

# 6in4 in
$IP4T -A INPUT -p 41 -j ACCEPT # Might as well for acme

# RDP in
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 --dport 3389 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 --dport 3389 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA --dport 3389 -j ACCEPT

# DNS in
# $IP4T -A INPUT -p udp --dport 53 -j ACCEPT
# $IP6T -A INPUT -p udp --dport 53 -j ACCEPT

# SMTP in
# $IP4T -A INPUT -p tcp --dport 25 -j ACCEPT
# $IP6T -A INPUT -p tcp --dport 25 -j ACCEPT

# SMTPS in
# $IP4T -A INPUT -p tcp --dport 587 -j ACCEPT
# $IP6T -A INPUT -p tcp --dport 587 -j ACCEPT

# Sauer in
$IP4T -A INPUT -p udp --dport 28785 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28785 -j ACCEPT
$IP4T -A INPUT -p udp --dport 28784 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28784 -j ACCEPT
$IP4T -A INPUT -p udp --dport 28786 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28786 -j ACCEPT

# Doomsday
$IP4T -A INPUT -p udp --dport 13209 -j ACCEPT
$IP6T -A INPUT -p udp --dport 13209 -j ACCEPT
$IP4T -A INPUT -p tcp --dport 13209 -j ACCEPT
$IP6T -A INPUT -p tcp --dport 13209 -j ACCEPT

# Game server discovery?
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4_ALL -m multiport --dport 13210:13224 -j ACCEPT # --sport 29312

# Internal networks
$IP4T -A INPUT -p tcp -s $PRIVNET4_12 -d $PRIVNET4_12 -j ACCEPT
$IP4T -A INPUT -p tcp -s $PRIVNET4_8 -d $PRIVNET4_8 -j ACCEPT

# DHCP
$IP4T -A INPUT -p udp -s $NULL4 -d $BCAST4_ALL --sport $DHCP4_CLIENT_PORT --dport $DHCP4_SERVER_PORT -j ACCEPT
$IP4T -A INPUT -p udp -s $GATEWAY4 -d $BCAST4_ALL --sport $DHCP4_SERVER_PORT --dport $DHCP4_CLIENT_PORT -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $LL6 --sport $DHCP6_SERVER_PORT --dport $DHCP6_CLIENT_PORT -j ACCEPT

# lo
$IP4T -A INPUT -i lo -j ACCEPT
$IP6T -A INPUT -i lo -j ACCEPT

# BitTorrent
$IP4T -A INPUT -p tcp -d $PRIVNET4_8 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_8 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_8 --sport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --sport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --sport 6881 -j ACCEPT
# $IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 6881 -j ACCEPT
# $IP6T -A INPUT -p udp -d $LL6 --dport 6881 -j ACCEPT
# $IP6T -A INPUT -p udp -d $ULA --dport 6881 -j ACCEPT

# aria2
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 -m multiport --dport 6881:6999 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 -m multiport --dport 6881:6999 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA -m multiport --dport 6881:6999 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 -m multiport --dport 6881:6999 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 -m multiport --dport 6881:6999 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA -m multiport --dport 6881:6999 -j ACCEPT

# DHT
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 7881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 7881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 7881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 7881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --dport 7881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --dport 7881 -j ACCEPT

# Tracker
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 8881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 8881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 8881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 8881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --dport 8881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --dport 8881 -j ACCEPT

# Steam Client
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 27015 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 27015 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 -m multiport --dport 27031:27036 -j ACCEPT
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 27036 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 27015 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 27015 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --dport 27015 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --dport 27015 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 -m multiport --dport 27031:27036 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA -m multiport --dport 27031:27036 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 27036 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 27036 -j ACCEPT

# FTP responses
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --sport 20 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --sport 20 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --sport 20 -j ACCEPT

# IGMP Multicast
$IP4T -A INPUT -p igmp -s $PRIVNET4_16 -d $MULTICAST4_4 -j ACCEPT
$IP4T -A INPUT -p igmp -s $NULL4 -d $MULTICAST4_4 -j ACCEPT
$IP6T -A INPUT -p igmp -s $LL6 -d $MULTICAST6_8 -j ACCEPT
$IP6T -A INPUT -p igmp -s $ULA -d $MULTICAST6_8 -j ACCEPT

# mDNS
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $MULTICAST4_4 --dport 5353 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $MULTICAST6_8 --dport 5353 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $MULTICAST6_8 --dport 5353 -j ACCEPT

# DLNA (TODO related?)
$IP4T -A INPUT -p udp -s $GATEWAY4 -d $PRIVNET4_16 --sport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $GATEWAY6 -d $LL6 --sport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $GATEWAY6 -d $ULA --sport 1900 -j ACCEPT

# Plex
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 -m multiport --dport 32400,32401 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 -m multiport --dport 32400,32401 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA -m multiport --dport 32400,32401 -j ACCEPT
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --sport 443 -j ACCEPT # psh?
$IP6T -A INPUT -p tcp -d $LL6 --sport 443 -j ACCEPT # psh?
$IP6T -A INPUT -p tcp -d $ULA --sport 443 -j ACCEPT # psh?

# Plex network discovery
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT

# DLNA
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_LL --dport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_LL --dport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_SL --dport 1900 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_SL --dport 1900 -j ACCEPT

# TV
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_LL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_LL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_SL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_SL --dport 15600 -j ACCEPT

# KDE Connect
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 -d $PRIVNET4_16 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 -d $LL6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA -d $ULA -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $PRIVNET4_16 -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4_ALL -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $LL6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $ULA -m multiport --dport 1714:1764 -j ACCEPT

# KDE Connect (Scanning)
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT

# Discord
$IP4T -A INPUT -p udp -d $PRIVNET4_16 -m multiport --dport 50000:65535 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 -m multiport --dport 50000:65535 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA -m multiport --dport 50000:65535 -j ACCEPT

# all local for now
$IP4T -A INPUT -s $PRIVNET4_16 -d $PRIVNET4_16 -j ACCEPT
$IP6T -A INPUT -s $LL6 -d $LL6 -j ACCEPT
$IP6T -A INPUT -s $ULA -d $ULA -j ACCEPT
$IP6T -A INPUT -s $LL6 -j ACCEPT
$IP6T -A INPUT -s $ULA -j ACCEPT
$IP6T -A INPUT -d $LL6 -j ACCEPT
$IP6T -A INPUT -d $ULA -j ACCEPT

# SMB
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 -m multiport --dport 137,139,445,5357 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 -m multiport --dport 137,139,445,5357 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA -m multiport --dport 137,139,445,5357 -j ACCEPT
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -m multiport --dport 3702 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -m multiport --dport 3702 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -m multiport --dport 3702 -j ACCEPT

# and all local broadcast
$IP4T -A INPUT -s $PRIVNET4_16 -d $BCAST4 -j ACCEPT
$IP6T -A INPUT -s $LL6 -d $ALL_IL_AN6 -j ACCEPT
$IP6T -A INPUT -s $ULA -d $ALL_IL_AN6 -j ACCEPT
$IP6T -A INPUT -s $LL6 -d $ALL_LL_AN6 -j ACCEPT
$IP6T -A INPUT -s $ULA -d $ALL_LL_AN6 -j ACCEPT

# all local on ham
$IP4T -A INPUT -s $AMPR_NET4 -d $AMPR_IP4 -j ACCEPT

$IP4T -A INPUT -i waydroid0 -j ACCEPT

# except ssh/https/ircs
$IP4T -A INPUT -s $AMPR_NET4 -d $AMPR_IP4 -p tcp -m multiport --dport 22,443,6697 -j DROP

# normally disable icmp but today allow it (todo rate limit)
$IP4T -A INPUT -p icmp -j ACCEPT

# ICMPv6 is more necessary than ICMPv4
$IP6T -A INPUT -p icmpv6 -j ACCEPT

# Invalid
$IP4T -A INPUT -m conntrack --ctstate INVALID -j DROP
$IP6T -A INPUT -m conntrack --ctstate INVALID -j DROP

# Existing
$IP4T -A INPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A INPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A INPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A INPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log
# $IP4T -A INPUT -j LOG --log-prefix "INPUT: DROP: " --log-level 4
# $IP6T -A INPUT -j LOG --log-prefix "INPUT: DROP: " --log-level 4

$IP4T -A INPUT -j NFLOG --nflog-group 2 --nflog-prefix "INPUT:"
$IP6T -A INPUT -j NFLOG --nflog-group 2 --nflog-prefix "INPUT:"

# Rest
$IP4T -A INPUT -j DROP
$IP6T -A INPUT -j DROP


## FORWARD
$IP4T -P FORWARD ACCEPT
$IP6T -P FORWARD ACCEPT

## OUTPUT
$IP4T -P OUTPUT ACCEPT
$IP6T -P OUTPUT ACCEPT

# Block harmful hosts
# $IP4T -A OUTPUT -p tcp --dport 443 -d 192.0.64.0/18 -j DROP # tum
$IP4T -A OUTPUT -p tcp --dport 443 -d 162.159.140.229 -j DROP # twtx's cloudflare
$IP4T -A OUTPUT -p tcp --dport 443 -d 172.66.0.227 -j DROP # twtx's cloudflare

# Mwahahaha
$HERE/../private/net/secret-firewall-entries.sh
