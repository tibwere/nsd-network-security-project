#!/bin/sh

net add vxlan vni-10 vxlan id 10
net add vxlan vni-20 vxlan id 20
net add vxlan vni-100 vxlan id 100
net add vxlan vni-1020 vxlan id 1020

net add bridge bridge ports vni-10,vni-20,vni-100,swp1,swp4,vni-1020
net add bridge bridge vids 10,20,50,100
net add bridge bridge vlan-aware

net add bridge bridge pvid 1
net add interface swp4 bridge access 100

net add interface swp2 ip add 2.10.1.1/30
net add interface swp3 ip add 2.10.2.1/30
net add loopback lo ip add 2.1.1.1/32

net add ospf router-id 2.1.1.1
net add ospf network 2.10.1.0/30 area 0
net add ospf network 2.10.2.0/30 area 0
net add ospf network 2.1.1.1/32 area 0
net add ospf passive-interface swp1
net add ospf passive-interface swp4

net add vxlan vni-10 vxlan local-tunnelip 2.1.1.1
net add vxlan vni-10 bridge access 10
net add vxlan vni-20 vxlan local-tunnelip 2.1.1.1
net add vxlan vni-20 bridge access 20
net add vxlan vni-100 vxlan local-tunnelip 2.1.1.1
net add vxlan vni-100 bridge access 100

net add bgp autonomous-system 65001
net add bgp router-id 2.1.1.1
net add bgp neighbor swp2 remote-as 65000
net add bgp neighbor swp3 remote-as 65000
net add bgp evpn neighbor swp2 activate
net add bgp evpn neighbor swp3 activate
net add bgp evpn advertise-all-vni

net add bgp vrf TEN1 autonomous-system 65001
net add bgp vrf TEN1 l2vpn evpn advertise ipv4 unicast
net add bgp vrf TEN1 l2vpn evpn default-originate ipv4

net add vlan 10 ip address 2.0.10.254/24
net add vlan 20 ip address 2.0.20.254/24
net add vlan 100 ip address 2.10.10.254/24
net add vlan 100 ip gateway 2.10.10.1
net add vlan 50
net add vxlan vni-1020 vxlan local-tunnelip 2.1.1.1
net add vxlan vni-1020 bridge access 50

net add vrf TEN1 vni 1020
net add vlan 50 vrf TEN1
net add vlan 10 vrf TEN1
net add vlan 20 vrf TEN1
net add vlan 100 vrf TEN1
