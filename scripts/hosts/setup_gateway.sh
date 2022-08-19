#!/bin/sh

ip link set enp0s3 up
ip addr flush dev enp0s3
ip addr add 2.20.22.2/24 dev enp0s3
ip route add default via 2.20.22.1

echo 1 > /proc/sys/net/ipv4/ip_forward
