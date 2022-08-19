#!/bin/sh

ip link set enp0s3 up
ip addr flush dev enp0s3
ip addr add 3.30.33.2/24 dev enp0s3
ip route add default via 3.30.33.1
