#!/bin/sh

ip link set enp0s3 up
ip addr flush dev enp0s3
ip addr add 2.20.22.2/24 dev enp0s3
ip route add default via 2.20.22.1

ip link set enp0s8 up
ip addr flush dev enp0s8
ip addr add 2.10.10.1/24 dev enp0s8
ip route add 2.0.10.0/24 via 2.10.10.254
ip route add 2.0.20.0/24 via 2.10.10.254

echo 1 > /proc/sys/net/ipv4/ip_forward
