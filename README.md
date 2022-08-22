# NSD project (network security) :globe_with_meridians::computer::shield:

__Authors__:

* :man_technologist: Alessandro Chillotti (M. 0299824)
* :man_technologist: Cristiano Cuffaro (M. 0299838)
* :man_technologist: Simone Tiberi (M. 0299908)

## Table of contents

1. [Network topology](#network-topology)
2. [Routers configuration](#routers-configuration)

    1. [Router R1](#router-r1)
    2. [Routers R2 and R3](#routers-r2-and-r3)
    3. [Router R4](#router-r4)
    4. [Routers R5 and R6](#routers-r5-and-r6)
    5. [Routers R7 and R8](#routers-r7-and-r8)
3. [Test cases](#test-cases)

## Network topology

The reference topology for the scripts presented in the following sections is the one shown in the following figure.

![Reference topology](./figs/topology.png "Reference topology")

## Routers configuration
The configuration scripts for each router inside the topology will be commented on in the following sections.

### Router R1
The IP interfaces were configured as follows:

* a loopback interface used for management purpose (i.e. iBGP configuration):

    ```
    interface Loopback0
    ip address 1.1.1.1 255.255.255.255
    ```

* a loopback interface used to simulate the presence of a host (useful for checking connectivity via `ping`/`traceroute`):

    ```
    interface Loopback1
    ip address 1.0.1.1 255.255.255.0
    ```

* an interface used to link R1 to the IXP LAN:

    ```
    interface GigabitEthernet1/0
    ip address 10.0.0.1 255.255.255.0
    no shutdown
    ```

* an interface used to link R1 to R4:

    ```
    interface GigabitEthernet2/0
    ip address 1.29.0.1 255.255.255.252
    no shutdown
    ```

OSPF has been configured as follows:

* the process has been defined:

    ```
    router ospf 1
    ```

* the identifier for the router has been set, using the `lo0` interface:

    ```
    router-id 1.1.1.1
    ```

* the networks are included inside the process assigned to backbone area (i.e., `area 0`):

    ```
    network 1.1.1.1 0.0.0.0 area 0
    network 1.29.0.0 0.0.0.3 area 0
    network 1.0.1.0 0.0.0.255 area 0
    ```

BGP has been configured as follows:

* for the iBGP peer R1, `next-hop-self` was used to mask the IXP addresses (to avoid DDoS attacks) and also the incoming routes were filtered on the basis of the value of the comunity through a specific `route map comm`:

    ```
    neighbor 1.4.4.4 remote-as 100
    neighbor 1.4.4.4 next-hop-self
    neighbor 1.4.4.4 update-source Loopback0
    neighbor 1.4.4.4 route-map comm in
    ```

* a peer group has been defined to avoid redundancy in the IXP neighbors configuration. In particular, input and output filters have been applied and the community value has been enabled:

    ```
    neighbor ixp-peer peer-group
    neighbor ixp-peer send-community
    neighbor ixp-peer route-map set-local-pref in
    neighbor ixp-peer route-map comm out
    ```

* finally, the prefixes coming in from the IXP peers were filtered:

    ```
    neighbor 10.0.0.2 prefix-list pl-peer200 in
    ! [...]
    neighbor 10.0.0.3 prefix-list pl-peer200 in
    ```

### Routers R2 and R3

Since R2 and R3 have similar configurations, the analysis of only the former is shown below.

The IP interfaces were configured as follows:

* a loopback interface used to simulate the presence of a host connected to the VPN (useful for checking connectivity via `ping`/`traceroute`):

    ```
    interface Loopback0
    ip address 2.0.0.1 255.255.255.0
    ```

* an interface used to reach AS 100:

    ```
    interface GigabitEthernet1/0
    ip address 10.0.0.2 255.255.255.0
    no shutdown
    ```

* an interface used to communicate with the AS 200:

    ```
    interface GigabitEthernet2/0
    ip address 2.20.22.1 255.255.255.0
    no shutdown
    ```

* in order to make the correct advertisement of the prefix 1.0.0.0/9 a static route has also been added:

```
ip route 2.0.0.0 255.0.0.0 null0
```

* as there are no other routers inside the AS it is not necessary to configure OSPF;

* BGP was configured as follows:

    * the local network has been advertised:

        ```
        network 2.0.0.0 mask 255.0.0.0
        ```

    * finally, the prefixes coming in from the IXP peers were filtered:

        ```
        neighbor 10.0.0.1 remote-as 100
        neighbor 10.0.0.1 prefix-list pl-peer100 in
        neighbor 10.0.0.3 remote-as 300
        neighbor 10.0.0.3 prefix-list pl-peer300 in
        ```

### Router R4
The IP interfaces were configured as follows:

* a loopback interface used for management purpose (i.e. iBGP configuration):

    ```
    interface Loopback0
    ip address 1.4.4.4 255.255.255.255
    ```

* a loopback interface used to simulate the presence of a host (useful for checking connectivity via `ping`/`traceroute`):

    ```
    interface Loopback1
    ip address 1.0.4.1 255.255.255.0
    ```

* an interface used to link R4 to R5, where `mpls ip` was used because packets between the two customers pass through this interface:

    ```
    interface GigabitEthernet1/0
    mpls ip
    ip address 1.29.0.5 255.255.255.252
    no shutdown
    ```

* an interface used to link R4 to R1:

    ```
    interface GigabitEthernet2/0
    ip address 1.29.0.2 255.255.255.252
    no shutdown
    ```

* an interface used to link R4 to R6, where `mpls ip` was used because packets between the two customers pass through this interface:

    ```
    interface GigabitEthernet3/0
    mpls ip
    ip address 1.29.0.9 255.255.255.252
    no shutdown
    ```

* an interface used to link R4 to the Open VPN server:

    ```
    interface GigabitEthernet4/0
    ip address 1.10.11.1 255.255.255.0
    no shutdown
    ```

OSPF has been configured as follows:

* the process has been defined:

    ```
    router ospf 1
    ```

* the identifier for the router has been set, using the `lo0` interface:

    ```
    router-id 1.4.4.4
    ```

* the networks are included inside the process assigned to backbone area (i.e., `area 0`):

    ```
    network 1.4.4.4 0.0.0.0 area 0
    network 1.29.0.0 0.0.0.3 area 0
    network 1.29.0.4 0.0.0.3 area 0
    network 1.29.0.8 0.0.0.3 area 0
    network 1.0.4.0 0.0.0.255 area 0
    ```

In order to make the correct advertisement of the prefix 1.0.0.0/9 a static route has also been added:

```
ip route 1.0.0.0 255.128.0.0 null0
```

BGP has been configured as follows:

* the 1.0.0.0/9 network is announced, also associating the community value:

    ```
    network 1.0.0.0 mask 255.128.0.0 route-map comm
    ```

* iBGP configurations with respect to R1, R5 and R6 are similar:

    ```
    neighbor 1.1.1.1 remote-as 100
    neighbor 1.1.1.1 route-reflector-client
    neighbor 1.1.1.1 update-source Loopback0
    neighbor 1.1.1.1 next-hop-self
    neighbor 1.1.1.1 send-community
    neighbor 1.5.5.5 remote-as 100
    neighbor 1.5.5.5 route-reflector-client
    neighbor 1.5.5.5 update-source Loopback0
    neighbor 1.6.6.6 remote-as 100
    neighbor 1.6.6.6 route-reflector-client
    neighbor 1.6.6.6 update-source Loopback0
    ```

    where:

    * towards R1 the community field is enabled to filter the incoming prefixes;

    * `route-reflector-client` is used for R4 to announce to R5 and R6 the routes learned from R1 to 2.0.0.0/8 and 3.0.0.0/8 (see [RFC 4456](https://www.rfc-editor.org/rfc/rfc4456.html) and the answer on [networkengineering.stackexchange.com](https://networkengineering.stackexchange.com/a/44909)).

### Router R5 and R6

Since R5 and R6 have similar configurations, the analysis of only the former is shown below.

The VRF for the `customers` VPN is defined by specifying route distinguisher and target:

```
ip vrf customers
rd 100:0
route-target export 100:1
route-target import 100:1
```

The IP interfaces were configured as follows:

* a loopback interface used for management purpose (i.e. iBGP configuration):

    ```
    interface Loopback0
    ip address 1.5.5.5 255.255.255.255
    ```

* a loopback interface used to simulate the presence of a host (useful for checking connectivity via `ping`/`traceroute`):

    ```
    interface Loopback1
    ip address 1.0.5.1 255.255.255.0
    ```

* an interface used to link R5 to R4, where `mpls ip` was used because packets between the two customers pass through this interface:

    ```
    interface GigabitEthernet1/0
    mpls ip
    ip address 1.29.0.6 255.255.255.252
    no shutdown
    ```

* an interface used to link R5 to R7, where `ip vrf forwarding customers` was used to enable VRF:

    ```
    interface GigabitEthernet2/0
    ip vrf forwarding customers
    ip address 10.0.1.1 255.255.255.252
    no shutdown
    ```

OSPF has been configured as follows:

* the process has been defined:

    ```
    router ospf 1
    ```

* the identifier for the router has been set, using the `lo0` interface:

    ```
    router-id 1.5.5.5
    ```

* the networks are included inside the process assigned to backbone area (i.e., `area 0`):

    ```
    network 1.5.5.5 0.0.0.0 area 0
    network 1.29.0.4 0.0.0.3 area 0
    network 1.0.5.0 0.0.0.255 area 0
    ```

A static route for VRF forwarding has been added:

```
ip route vrf customers 192.168.0.0 255.255.255.0 10.0.1.2
```

The iBGP relationship with other routers inside the AS are defined:

```
router bgp 100
neighbor 1.4.4.4 remote-as 100
neighbor 1.6.6.6 remote-as 100
neighbor 1.6.6.6 update-source Loopback0
```

VPNV4 peerings is enabled:

```
address-family vpnv4
neighbor 1.6.6.6 activate
neighbor 1.6.6.6 send-community extended
exit-address-family
```

BGP advertisements of VRF are switched on:

```
address-family ipv4 vrf customers
network 192.168.0.0
exit-address-family
```

### Router R7 and R8

Since R7 and R8 have similar configurations, the analysis of only the former is shown below.

The IP interfaces were configured as follows:

* an interface used to link R7 to R5:

    ```
    interface GigabitEthernet1/0
    ip address 10.0.1.2 255.255.255.252
    no shutdown
    ```

* an interface used to link R7 to the host:

    ```
    interface GigabitEthernet1/0
    ip address 192.168.0.1 255.255.255.0
    no shutdown
    ```

A static route for any packet from any IP address with any subnet mask:

```
ip route 0.0.0.0 0.0.0.0 10.0.1.1
```

## Test cases

### BGP/MPLS VPN

1. examine MPLS forwarding table on R5/R6 (_there should be VPNs configured_):

    ```
    show mpls forwarding-table
    ```

2. examine the routes associated with VPN A on R5/R6

    ```
    show ip route vrf customers
    ```

3. configure the customer hosts using the `scripts/hosts/customer.sh` script with sudo privileges as follows:

    * on `customer-A`:

        ```
        /path/to/customers.sh 192.168.0.2 192.168.0.1
        ```

    * on `customer-B`:

        ```
        /path/to/customers.sh 192.168.1.2 192.168.1.1
        ```

    and then verify the connectivity using;

    ```
    ping 192.168.X.2 # where x is 1 if executed on customer-a and 0 otherwise
    ```
