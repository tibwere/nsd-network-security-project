#!/bin/sh

net add interface swp1 ip add 2.10.1.2/30
net add interface swp2 ip add 2.20.1.2/30
net add loopback lo ip add 2.3.3.3/32

net add ospf router-id 2.3.3.3
net add ospf network 2.10.1.0/30 area 0
net add ospf network 2.20.1.0/30 area 0
net add ospf network 2.3.3.3/32 area 0

net add bgp autonomous-system 65000
net add bgp router-id 2.3.3.3
net add bgp neighbor swp1 remote-as external
net add bgp neighbor swp2 remote-as external
net add bgp evpn neighbor swp1 activate
net add bgp evpn neighbor swp2 activate
