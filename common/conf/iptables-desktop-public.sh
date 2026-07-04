#!/bin/sh
set -euo pipefail
trap pwd ERR

# This script gets dumped into the system one instead of being called!
HERE=$HOME_DIRECTORY/code/mine/nix/system/common/conf
source $HERE/common.sh

$IP4T -F

## INPUT
$IP4T -P INPUT DROP

# Web in
$IP4T -A INPUT -p tcp --dport 80 -j ACCEPT # Might as well for acme
$IP4T -A INPUT -p tcp --dport 443 -j ACCEPT

# Dev MySQL
# $IP4T -A INPUT -p tcp -s $PRIVNET4_12 --dport 3306 -j ACCEPT

# Internal networks
$IP4T -A INPUT -p tcp -s $PRIVNET4_12 -d $PRIVNET4_12 -j ACCEPT

# DHCP
$IP4T -A INPUT -p udp -s $THISNET4 -d $BCAST4 --sport $DHCP4_CLIENT_PORT --dport $DHCP4_SERVER_PORT -j ACCEPT
$IP4T -A INPUT -p udp -s $GATEWAY4 -d $BCAST4 --sport $DHCP4_SERVER_PORT --dport $DHCP4_CLIENT_PORT -j ACCEPT

# BitTorrent
$IP4T -A INPUT -p tcp --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp --dport 6881 -j ACCEPT
$IP4T -A INPUT -p udp --sport 6881 -j ACCEPT
# $IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 6881 -j ACCEPT

# DHT
$IP4T -A INPUT -p tcp --dport 7881 -j ACCEPT
$IP4T -A INPUT -p udp --dport 7881 -j ACCEPT

# Tracker
# $IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 8881 -j ACCEPT
# $IP4T -A INPUT -p udp -d $PRIVNET4_16 --dport 8881 -j ACCEPT

# FTP responses
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --sport 20 -j ACCEPT

# IGMP Multicast
$IP4T -A INPUT -p igmp -s $GATEWAY4 -d $MULTICAST4_4 -j ACCEPT

# mDNS
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $MULTICAST4_4 --sport 5353 --dport 5353 -j ACCEPT

# DLNA (TODO related?)
$IP4T -A INPUT -p udp -s $GATEWAY4 -d $PRIVNET4_16 --sport 1900 -j ACCEPT

# Plex
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 -m multiport --dport 32400,32401 -j ACCEPT
$IP4T -A INPUT -p tcp -d $PRIVNET4_16 --sport 443 -j ACCEPT # psh?

# Plex network discovery
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT

# DLNA
$IP4T -A INPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT

# Mail server
# $IP4T -A INPUT -p tcp -d $PRIVNET4_16 --dport 25 -j ACCEPT

# all local for now
$IP4T -A INPUT -s $PRIVNET4_16 -d $PRIVNET4_16 -j ACCEPT

# and all local broadcast
$IP4T -A INPUT -s $PRIVNET4_16 -d $BCAST4 -j ACCEPT

# all local on ham
$IP4T -A INPUT -s $AMPR_NET4 -d $AMPR_IP4 -j ACCEPT

# except ssh/https/ircs
$IP4T -A INPUT -s $AMPR_NET4 -d $AMPR_IP4 -p tcp -m multiport --dport 22,443,6697 -j REJECT

# lo
$IP4T -A INPUT -s $LOCAL4_8 -d $LOCAL4_8 -i lo -j ACCEPT

# Invalid
$IP4T -A INPUT -m conntrack --ctstate INVALID -j DROP

# Existing
$IP4T -A INPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A INPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log
$IP4T -A INPUT -j LOG --log-prefix "INPUT: REJECT: " --log-level 4

# Rest
$IP4T -A INPUT -j REJECT


## FORWARD
$IP4T -P FORWARD DROP

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
$IP4T -A FORWARD -j LOG --log-prefix "FORWARD: REJECT: " --log-level 4

# Existing
$IP4T -A FORWARD -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A FORWARD -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Rest
$IP4T -A FORWARD -j REJECT


## OUTPUT
$IP4T -P OUTPUT DROP

# Debug
$IP4T -A OUTPUT -p tcp --dport 80 -j ACCEPT

# Web out
$IP4T -A OUTPUT -p tcp --dport 443 -j ACCEPT

# SSH out
$IP4T -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Gmail SMTP TLS out
$IP4T -A OUTPUT -p tcp --dport 587 -j ACCEPT

# IMAP TLS out
$IP4T -A OUTPUT -p tcp --dport 993 -j ACCEPT

# DNS out
$IP4T -A OUTPUT -p udp --dport 53 -j ACCEPT

# DHCP
$IP4T -A OUTPUT -p udp --dport $DHCP4_SERVER_PORT -j ACCEPT

# SSDP4
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 --dport 1900 -j ACCEPT

# NAT port mapping
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $GATEWAY4 --dport 5351 -j ACCEPT

# NTP
$IP4T -A OUTPUT -p udp --dport 123 -j ACCEPT

# Google Meet
$IP4T -A OUTPUT -p udp --dport 19302:19309 -j ACCEPT

# Docker
# $IP4T -A OUTPUT -p tcp -s $PRIVNET4_12 -d $PRIVNET4_12 -j ACCEPT

# Roqqett
$IP4T -A OUTPUT -p tcp --dport 5000:6000 -j ACCEPT
$IP4T -A OUTPUT -p tcp -d $PRIVNET4_12 --dport 80 -j ACCEPT # TODO related
$IP4T -A OUTPUT -p tcp -d $PRIVNET4_12 --dport 8080 -j ACCEPT # TODO related

# MDNS Out
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $MULTICAST4_4 --sport 5353 --dport 5353 -j ACCEPT

# NetBIOS
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 --sport 137 --dport 137 -j ACCEPT

# Plex network discovery - still gets blocked somehow
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $BCAST4 -m multiport --dport 32410,32412,34213,32414 -j ACCEPT

# DLNA (SSDP4/UPnP)
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 -d $SSDP4 --dport 1900 -j ACCEPT

# BitTorrent
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --sport 6881 -j ACCEPT # related?
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 6881 -j ACCEPT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 6881 -j ACCEPT # related?

# DHT
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 7881 -j ACCEPT

# Tracker
$IP4T -A OUTPUT -p udp -s $PRIVNET4_16 --sport 8881 -j ACCEPT

# irc
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 6697 -j ACCEPT

# whois
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 43 -j ACCEPT

# FTP
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 21 -j ACCEPT

# SMB
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 --dport 445 -j ACCEPT

# websdr
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_16 -d 192.87.173.88 --dport 8901 -j ACCEPT

# all local on ham
$IP4T -A OUTPUT -s $AMPR_IP4 -d $AMPR_NET4 -j ACCEPT

# except ssh/https/ircs
$IP4T -A OUTPUT -s $AMPR_IP4 -d $AMPR_NET4 -p tcp -m multiport --dport 22,443,6697 -j REJECT

# lo
$IP4T -A OUTPUT -s $LOCAL4_8 -d $LOCAL4_8 -o lo -j ACCEPT

# all from VPN
$IP4T -A OUTPUT -p tcp -s $PRIVNET4_8 -d $PRIVNET4_12 -j ACCEPT

# objects-us-east-1.dream.io for nix
# $IP4T -A OUTPUT -p tcp --dport 80 -d 208.113.201.37 -j ACCEPT
# ip6tables-nft -A OUTPUT -p tcp --dport 80 -d 2607:f298:5:ee00::33 -j ACCEPT


# all local for now
$IP4T -A OUTPUT -s $PRIVNET4_16 -d $PRIVNET4_16 -j ACCEPT

# Existing
$IP4T -A OUTPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IP4T -A OUTPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log
$IP4T -A OUTPUT -j LOG --log-prefix "OUTPUT: REJECT: " --log-level 4

# Rest
$IP4T -A OUTPUT -j REJECT
