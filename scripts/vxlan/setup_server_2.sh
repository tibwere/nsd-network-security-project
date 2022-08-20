#!/bin/sh

ip netns add subA
ip netns add subB
ip link add link enp0s8 name enp0s8.10 type vlan id 10
ip link add link enp0s8 name enp0s8.20 type vlan id 20
ip link set enp0s8.10 netns subA
ip link set enp0s8.20 netns subB
ip netns exec subA ip addr add 2.0.10.2/24 dev enp0s8.10
ip netns exec subB ip addr add 2.0.20.2/24 dev enp0s8.20
ip link set enp0s8 up
ip netns exec subA ip link set enp0s8.10 up
ip netns exec subB ip link set enp0s8.20 up
ip netns exec subA ip route add default via 2.0.10.254
ip netns exec subB ip route add default via 2.0.20.254
