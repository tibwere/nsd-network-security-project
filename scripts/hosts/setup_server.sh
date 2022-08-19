#!/bin/sh

ip link set enp0s3 up
ip addr flush dev enp0s3
ip addr add 1.10.11.2/24 dev enp0s3
ip route add default via 1.10.11.1

echo 1 > /proc/sys/net/ipv4/ip_forward
