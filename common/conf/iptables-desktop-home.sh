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
$IP4T -A INPUT -p tcp --dport 2345 -s $PRIVNET4_16 -j ACCEPT
$IP6T -A INPUT -p tcp --dport 2345 -s $LL6 -j ACCEPT
$IP6T -A INPUT -p tcp --dport 2345 -s $ULA -j ACCEPT

# RDP in
$IP4T -A INPUT -p tcp -s $PRIVNET4_16 --dport 3389 -j ACCEPT
$IP6T -A INPUT -p tcp -s $LL6 --dport 3389 -j ACCEPT
$IP6T -A INPUT -p tcp -s $ULA --dport 3389 -j ACCEPT

# Web in
$IP4T -A INPUT -p tcp --dport 80 -j ACCEPT # Might as well for acme
$IP6T -A INPUT -p tcp --dport 80 -j ACCEPT # Might as well for acme
$IP4T -A INPUT -p tcp --dport 443 -j ACCEPT
$IP4T -A INPUT -p udp --dport 443 -j ACCEPT # quic
$IP6T -A INPUT -p tcp --dport 443 -j ACCEPT
$IP6T -A INPUT -p udp --dport 443 -j ACCEPT # quic

# SMTP in
# $IP4T -A INPUT -p tcp --dport 25 -j ACCEPT
# $IP6T -A INPUT -p tcp --dport 25 -j ACCEPT

# SMTPS in
# $IP4T -A INPUT -p tcp --dport 587 -j ACCEPT
# $IP6T -A INPUT -p tcp --dport 587 -j ACCEPT

# Sauer in
$IP4T -A INPUT -p udp --dport 28784 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28784 -j ACCEPT
$IP4T -A INPUT -p udp --dport 28785 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28785 -j ACCEPT
$IP4T -A INPUT -p udp --dport 28786 -j ACCEPT
$IP6T -A INPUT -p udp --dport 28786 -j ACCEPT

# Doomsday
$IP4T -A INPUT -p udp --dport 13209 -j ACCEPT
$IP6T -A INPUT -p udp --dport 13209 -j ACCEPT
$IP4T -A INPUT -p tcp --dport 13209 -j ACCEPT
$IP6T -A INPUT -p tcp --dport 13209 -j ACCEPT

# Game server discovery?
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4_ALL -m multiport --dport 13210:13224 # --sport 29312

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
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $LL6 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p tcp -d $ULA --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --dport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp -d $PRIVNET4_16 --sport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $LL6 --sport 6881 -j ACCEPT
$IP6T -A INPUT -p udp -d $ULA --sport 6881 -j ACCEPT
# $IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 6881 -j ACCEPT
# $IP6T -A INPUT -p udp -d $LL6 --dport 6881 -j ACCEPT

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

# TV
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_LL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_LL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $LL6 -d $SSDP6_SL --dport 15600 -j ACCEPT
$IP6T -A INPUT -p udp -s $ULA -d $SSDP6_SL --dport 15600 -j ACCEPT

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
$IP4T -P FORWARD DROP
$IP6T -P FORWARD DROP

# Docker
# $IP4T -A FORWARD -p tcp -s $PRIVNET4_12 -d $PRIVNET4_12 -j ACCEPT

$IP4T -A FORWARD -p tcp --sport 443 -d $PRIVNET4_12 -j ACCEPT
$IP4T -A FORWARD -p tcp --dport 443 -s $PRIVNET4_12 -j ACCEPT

$IP4T -A FORWARD -p tcp --sport 22 -d $PRIVNET4_12 -j ACCEPT
$IP4T -A FORWARD -p tcp --dport 22 -s $PRIVNET4_12 -j ACCEPT

$IP4T -A FORWARD -p udp --sport 53 -d $PRIVNET4_12 -j ACCEPT # TODO related
$IP4T -A FORWARD -p udp --dport 53 -s $PRIVNET4_12 -j ACCEPT

$IP4T -A FORWARD -p udp --sport $DHCP4_SERVER_PORT -d $PRIVNET4_12 -j ACCEPT # TODO related
$IP4T -A FORWARD -p udp --dport $DHCP4_SERVER_PORT -s $PRIVNET4_12 -j ACCEPT

$IP4T -A FORWARD -p tcp -d $PRIVNET4_12 --dport 80 -j ACCEPT # TODO related

$IP4T -A FORWARD -p tcp -d $PRIVNET4_12 --dport 8080 -j ACCEPT # TODO related

# Log
# $IP4T -A FORWARD -j LOG --log-prefix "FORWARD: DROP: " --log-level 4
# $IP6T -A FORWARD -j LOG --log-prefix "FORWARD: DROP: " --log-level 4

$IP4T -A FORWARD -j NFLOG --nflog-group 2 --nflog-prefix "FORWARD:"
$IP6T -A FORWARD -j NFLOG --nflog-group 2 --nflog-prefix "FORWARD:"

# Existing
$IP4T -A FORWARD -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A FORWARD -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A FORWARD -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A FORWARD -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Rest
$IP4T -A FORWARD -j DROP
$IP6T -A FORWARD -j DROP


## OUTPUT
$IP4T -P OUTPUT DROP
$IP6T -P OUTPUT DROP

# Debug
$IP4T -A OUTPUT -p tcp --dport 80 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 80 -j ACCEPT

# Web out
$IP4T -A OUTPUT -p tcp --dport 443 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 443 -j ACCEPT

# HTTP3
$IP4T -A OUTPUT -p udp --dport 443 -j ACCEPT
$IP6T -A OUTPUT -p udp --dport 443 -j ACCEPT

# SSH out
$IP4T -A OUTPUT -p tcp --dport 22 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Gmail SMTP TLS out
$IP4T -A OUTPUT -p tcp --dport 587 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 587 -j ACCEPT

# IMAP TLS out
$IP4T -A OUTPUT -p tcp --dport 993 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 993 -j ACCEPT

# SMTP out
$IP4T -A OUTPUT -p tcp --dport 25 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 25 -j ACCEPT

# SMTPS out
$IP4T -A OUTPUT -p tcp --dport 587 -j ACCEPT
$IP6T -A OUTPUT -p tcp --dport 587 -j ACCEPT

# DNS out
$IP4T -A OUTPUT -p udp --dport 53 -j ACCEPT
$IP6T -A OUTPUT -p udp --dport 53 -j ACCEPT

# DHCP
$IP4T -A OUTPUT -p udp --dport $DHCP4_SERVER_PORT -j ACCEPT
$IP6T -A OUTPUT -p udp --sport $DHCP6_CLIENT_PORT --dport $DHCP6_SERVER_PORT -s $LL6 -d $ALL_DHCP6 -j ACCEPT

# SSDP4
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 --dport 1900 -j ACCEPT

# NAT port mapping
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $GATEWAY4 --dport 5351 -j ACCEPT

# NTP
$IP4T -A OUTPUT -p udp --dport 123 -j ACCEPT
$IP6T -A OUTPUT -p udp --dport 123 -j ACCEPT

# Google Meet
$IP4T -A OUTPUT -p udp -m multiport --dport 19302:19309 -j ACCEPT
$IP6T -A OUTPUT -p udp -m multiport --dport 19302:19309 -j ACCEPT

# Docker
# $IP4T -A OUTPUT -p tcp -s $PRIVNET4_12 -d $PRIVNET4_12 -j ACCEPT

# Roqqett
$IP4T -A OUTPUT -p tcp -m multiport --dport 5000:6000 -j ACCEPT
$IP6T -A OUTPUT -p tcp -m multiport --dport 5000:6000 -j ACCEPT
$IP4T -A OUTPUT -p tcp -d $PRIVNET4_12 --dport 80 -j ACCEPT # TODO related
$IP4T -A OUTPUT -p tcp -d $PRIVNET4_12 --dport 8080 -j ACCEPT # TODO related

# IGMP Multicast
$IP4T -A OUTPUT -p igmp -s $PRIVNET4_16 -d $MULTICAST4_4 -j ACCEPT
$IP4T -A OUTPUT -p igmp -s $NULL4 -d $MULTICAST4_4 -j ACCEPT
$IP6T -A OUTPUT -p igmp -s $LL6 -d $MULTICAST6_8 -j ACCEPT
$IP6T -A OUTPUT -p igmp -s $ULA -d $MULTICAST6_8 -j ACCEPT

# MDNS Out
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $MULTICAST4_4 --dport 5353 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $MULTICAST6_8 --dport 5353 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $MULTICAST6_8 --dport 5353 -j ACCEPT

# NetBIOS
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 --sport 137 --dport 137 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_IL_AN6 --sport 137 --dport 137 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_IL_AN6 --sport 137 --dport 137 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_LL_AN6 --sport 137 --dport 137 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_LL_AN6 --sport 137 --dport 137 -j ACCEPT

# Plex network discovery - still gets blocked somehow
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT

# DLNA (SSDP4/UPnP)
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $SSDP6_LL --dport 1900 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $SSDP6_LL --dport 1900 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $SSDP6_SL --dport 1900 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $SSDP6_SL --dport 1900 -j ACCEPT


# KDE Connect
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -d $PRIVNET4_16 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -d $LL6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -d $ULA -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $PRIVNET4_16 -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4_ALL -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $LL6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ULA -m multiport --dport 1714:1764 -j ACCEPT

# KDE Connect (Scanning)
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_IL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -d $ALL_LL_AN6 -m multiport --dport 1714:1764 -j ACCEPT

# BitTorrent
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --sport 6881 -j ACCEPT # related?
$IP6T -A OUTPUT -p tcp -s $LL6 --sport 6881 -j ACCEPT # related?
$IP6T -A OUTPUT -p tcp -s $ULA --sport 6881 -j ACCEPT # related?
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 6881 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 --dport 6881 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA --dport 6881 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 6881 -j ACCEPT # related?
$IP6T -A OUTPUT -p udp -s $LL6 --sport 6881 -j ACCEPT # related?
$IP6T -A OUTPUT -p udp -s $ULA --sport 6881 -j ACCEPT # related?

# DHT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 7881 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 --sport 7881 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA --sport 7881 -j ACCEPT

# Tracker
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 8881 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 --sport 8881 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA --sport 8881 -j ACCEPT

# Steam Client
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -m multiport --dport 27015:27050 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -m multiport --dport 27015:27050 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -m multiport --dport 27014:27030 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -m multiport --dport 27000:27100 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --dport 3478 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --dport 4379 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --dport 4380 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -m multiport --dport 27015:27050 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -m multiport --dport 27015:27050 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -m multiport --dport 27015:27050 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -m multiport --dport 27015:27050 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -m multiport --dport 27014:27030 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -m multiport --dport 27014:27030 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -m multiport --dport 27000:27100 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -m multiport --dport 27000:27100 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 --dport 3478 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA --dport 3478 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 --dport 4379 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA --dport 4379 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 --dport 4380 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA --dport 4380 -j ACCEPT

# irc
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 6697 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 --dport 6697 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA --dport 6697 -j ACCEPT

# whois
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 43 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 --dport 43 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA --dport 43 -j ACCEPT

# FTP
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 21 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 --dport 21 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA --dport 21 -j ACCEPT

# SMB
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $LL6 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p tcp -s $ULA -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $LL6 -m multiport --dport 137,139,445,3702,5357 -j ACCEPT
$IP6T -A OUTPUT -p udp -s $ULA -m multiport --dport 137,139,445,3702,5357 -j ACCEPT

# websdr
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -d 192.87.173.88 --dport 8901 -j ACCEPT

# all local on ham
$IP4T -A OUTPUT -s $AMPR_IP4 -d $AMPR_NET4 -j ACCEPT

# except ssh/https/ircs
$IP4T -A OUTPUT -s $AMPR_IP4 -d $AMPR_NET4 -p tcp -m multiport --dport 22,443,6697 -j DROP

# lo
$IP4T -A OUTPUT -s $LOCAL4_8 -d $LOCAL4_8 -o lo -j ACCEPT
$IP6T -A OUTPUT -s $LOCAL6_128 -d $LOCAL6_128 -o lo -j ACCEPT

# all from VPN
$IP4T -A OUTPUT -s $PRIVNET4_16 -d $PRIVNET4_8 -j ACCEPT

# objects-us-east-1.dream.io for nix
# $IP4T -A OUTPUT -p tcp --dport 80 -d 208.113.201.37 -j ACCEPT
# ip6tables-nft -A OUTPUT -p tcp --dport 80 -d 2607:f298:5:ee00::33 -j ACCEPT

# lo
$IP4T -A INPUT -i lo -j ACCEPT
$IP6T -A INPUT -i lo -j ACCEPT

# all local for now
$IP4T -A OUTPUT -s $PRIVNET4_16 -d $PRIVNET4_16 -j ACCEPT
$IP6T -A OUTPUT -s $LL6 -j ACCEPT
$IP6T -A OUTPUT -s $ULA -j ACCEPT
$IP6T -A OUTPUT -d $LL6 -j ACCEPT
$IP6T -A OUTPUT -d $ULA -j ACCEPT

# ICMPv6 is more necessary than ICMPv4
$IP6T -A OUTPUT -p icmpv6 -j ACCEPT

# Existing
$IP4T -A OUTPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A OUTPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A OUTPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP6T -A OUTPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log
# $IP4T -A OUTPUT -j LOG --log-prefix "OUTPUT: DROP: " --log-level 4
# $IP6T -A OUTPUT -j LOG --log-prefix "OUTPUT: DROP: " --log-level 4

$IP4T -A OUTPUT -j NFLOG --nflog-group 2 --nflog-prefix "OUTPUT:"
$IP6T -A OUTPUT -j NFLOG --nflog-group 2 --nflog-prefix "OUTPUT:"

# Rest
$IP4T -A OUTPUT -j DROP
$IP6T -A OUTPUT -j DROP

# Mwahahaha
$HERE/../private/net/secret-firewall-entries.sh