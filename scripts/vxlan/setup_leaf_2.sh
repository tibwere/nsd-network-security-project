#!/bin/sh

net add vxlan vni-10 vxlan id 10
net add vxlan vni-20 vxlan id 20
net add vxlan vni-1020 vxlan id 1020

net add bridge bridge ports vni-10,vni-20,swp1,vni-1020
net add bridge bridge vids 10,20,50
net add bridge bridge vlan-aware

net add interface swp2 ip add 2.20.1.1/30
net add interface swp3 ip add 2.20.2.1/30
net add loopback lo ip add 2.2.2.2/32

net add ospf router-id 2.2.2.2
net add ospf network 2.20.1.0/30 area 0
net add ospf network 2.20.2.0/30 area 0
net add ospf network 2.2.2.2/32 area 0
net add ospf passive-interface swp1

net add vxlan vni-10 vxlan local-tunnelip 2.2.2.2
net add vxlan vni-10 bridge access 10
net add vxlan vni-20 vxlan local-tunnelip 2.2.2.2
net add vxlan vni-20 bridge access 20

net add bgp autonomous-system 65002
net add bgp router-id 2.2.2.2
net add bgp neighbor swp2 remote-as 65000
net add bgp neighbor swp3 remote-as 65000
net add bgp evpn neighbor swp2 activate
net add bgp evpn neighbor swp3 activate
net add bgp evpn advertise-all-vni

net add vlan 10 ip address 2.0.10.254/24
net add vlan 20 ip address 2.0.20.254/24

net add vlan 50
net add vxlan vni-1020 vxlan local-tunnelip 2.2.2.2
net add vxlan vni-1020 bridge access 50

net add vrf TEN1 vni 1020
net add vlan 50 vrf TEN1
net add vlan 10 vrf TEN1
net add vlan 20 vrf TEN1
