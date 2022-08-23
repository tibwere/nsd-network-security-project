#!/bin/sh

[ $# -ne 2 ] && echo "usage: $0 addr def-gw" && exit 1

ip link set enp0s3 up
ip addr flush dev enp0s3
ip addr add ${1}/24 dev enp0s3
ip route add default via ${2}
