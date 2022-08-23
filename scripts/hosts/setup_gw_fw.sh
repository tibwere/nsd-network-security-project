#!/bin/sh

VPNServer="1.10.11.2"
WAN="enp0s3"
VXLAN="enp0s8"
TUN="tun0"

ip link set $WAN up
ip addr flush dev $WAN
ip addr add 2.32.22.2/30 dev $WAN
ip route add default via 2.32.22.1

ip link set $VXLAN up
ip addr flush dev $VXLAN
ip addr add 2.10.10.1/24 dev $VXLAN
ip route add 2.0.0.0/11 via 2.10.10.254

echo 1 > /proc/sys/net/ipv4/ip_forward

# Flush rules
iptables -F

# Default policies
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP

# Forward chain
iptables -A FORWARD -i $VXLAN -d $VPNServer -p udp --dport 1194 -o $TUN -j ACCEPT
iptables -A FORWARD -i $TUN -s $VPNServer -p udp --sport 1194 -o $VXLAN -j ACCEPT
iptables -A FORWARD -i $VXLAN -p icmp -o $TUN -j ACCEPT
iptables -A FORWARD -i $TUN -p icmp -o $VXLAN -j ACCEPT

# Input chain
iptables -A INPUT -i $WAN -s $VPNServer -p udp --sport 1194 -j ACCEPT
iptables -A INPUT -i $VXLAN -p icmp -j ACCEPT
iptables -A INPUT -i $TUN -p icmp -j ACCEPT

# Output chain
iptables -A OUTPUT -o $WAN -d $VPNServer -p udp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p icmp -o $VXLAN -j ACCEPT
iptables -A OUTPUT -p icmp -o $TUN -j ACCEPT
