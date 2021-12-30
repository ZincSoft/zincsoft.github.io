Catnet Protocol Version 0 (CPv0)

# Overview

## Terminology

### Node
A device that implements CPv0.

### Router
A node that forwards CPv0 packets not explicitly addressed to itself.

### Host
Any node that is not a router.

### Upper layer 
A protocol layer immediately above CPv0. Examples are transport protocols such as ATP (Advanced Transmission Protocol) and DTP (Datagram Transmission Protocol), and control protocols such as WUPS (Weird Underlying-transmission Peril System).

### Link
A communication facility or medium over which nodes can communicate at the link layer, i.e., the layer immediately below CPv0. Examples are Ethernets (simple or bridged); PPP links; X.25, Frame Relay, or ATM networks; and catnet-layer or higher-layer "tunnels", such as tunnels over CPv0 itself.

### Neighbors 
Nodes attached to the same link.

### Interface
A node's attachment to a link.

### Address
An CPv0-layer identifier for an interface or a set of interfaces.

### Packet
An CPv0 header plus payload.

### Link MTU
The maximum transmission unit, i.e., maximum packet size in octets, that can be conveyed over a link.

### Path MTU
The minimum link MTU of all the links in a path between a source node and a destination node.

## Motivation
The Catnet Protocol is designed for use in interconnected systems of packet-switched computer communication networks. Such a system has been dubbed Catnet. The Catnet Protcol provides for transmitting blocks of data called datagrams from sources to destinations, where sources and destinations are hosts identified by fixed length addresses. The Catnet Protcol also provides for fragmentation and reassembly of large datagrams in order to parallize the process of exchange.

## Scope
The Catnet Protcol is specifically limited in scope to provide the functions necessary to deliver a package of bits (an Catnet datagram) from a source to a destination over an interconnected system of networks. There are no mechanisms to augment end-to-end data reliability, flow control, sequencing, or other services commonly found in host-to-host protocols. The Catnet Protcol can capitalize on the services of its supporting networks to provide various types and qualities of service.

## Interfaces
This protocol is called on by host-to-host protocols in an Catnet environment. This protocol calls on local network protocols to carry the Catnet datagram to the next gateway or destination host.

For example, a ATP module would call on the Catnet module to take a ATP segment (including the ATP header and user data) as the data portion of an Catnet datagram. The ATP module would provide the addresses and other parameters in the Catnet header to the Catnet module as arguments of the call. The Catnet module would then create an Catnet datagram and call on the local network interface to transmit the Catnet datagram.

## Operation
The Catnet protocol implements two basic functions: addressing and fragmentation.

The Catnet modules use the addresses carried in the Catnet header to transmit Catnet datagrams toward their destinations. The selection of a path for transmission is called routing.

The Catnet modules use fields in the Catnet header to fragment and reassemble Catnet datagrams when necessary for transmission.

The model of operation is that an Catnet module resides in each host engaged in Catnet communication and in each gateway thatinterconnects networks. These modules share common rules for interpreting address fields and for fragmenting and assembling Catnet datagrams. In addition, these modules (especially in gateways) have procedures for making routing decisions and other functions.

The Catnet protocol treats each Catnet datagram as an independent entity unrelated to any other Catnet datagram. There are no connections or logical circuits (virtual or otherwise).

The Catnet protocol does not provide a reliable communication facility. There are no acknowledgments either end-to-end or hop-by-hop. There is no error control for data, only a header checksum. There are no retransmissions. There is no flow control.

Errors detected may be reported via the WUPS which is implemented in the Catnet protocol module.

## Relation to other protocols
The following diagram illustrates the place of the Catnet protocol in the protocol hierarchy:

~~~
+--------+ +------+ +------+ 
| BeeNet | | RFTP | | UFTP |
+--------+ +------+ +------+
        |   |          |
       +-----+      +-----+
       | ATP |      | EDP |
       +-----+      +-----+
          |            |
 +-------------------------------+
 |     Catnet Protocol & ICMP    |
 +-------------------------------+
                 |
   +---------------------------+
   |   Local Network Protocol  |
   +---------------------------+

Protocol Relationships

Figure 1.
~~~

Catnet protocol interfaces on one side to the higher level host-to-host protocols and on the other side to the local network protocol. In this context a "local network" may be a small network in a building or a large network such as the entire Catnet.

## Model of Operation

The model of operation for transmitting a fragmented datagram from one application program to another is illustrated by the following scenario:

1. We suppose that this transmission will involve one intermediate gateway.

2. The sending application program prepares its data and calls on its local Catnet module, which then fragments that data to send as a datagram and passes the destination address and other parameters as arguments of the call.

3. The Catnet module prepares the datagram headers and attaches the data(s) to it. The Catnet module determines a local network address for this Catnet address, in this case it is the address of a gateway.

4. It sends these datagrams and the local network address to the local network interface.

5. The local network interface creates a local network header, and attaches the datagram to it, then sends the result via the local network.

6. The datagrams arrives at a gateway host wrapped in the local network header, the local network interface strips off this header, and turns the datagrams over to the Catnet module. The Catnet module determines from the Catnet address that the datagrams is to be forwarded to another host in a second network. The Catnet module determines a local net address for the destination host. It calls on the local network interface for that network to send the datagrams.

7. This local network interface creates a local network header and attaches the datagram sending the result to the destination host.

8. At this destination host, all datagrams are waited for, and the datagram is stripped of the local net header by the local network interface and handed to the Catnet module.

The Catnet module determines that the datagrams is for an application program in this host. It passes the data to the application program in response to a system call, passing the source address and other parameters as results of the call.

### Diagram
~~~
 Application                                        Application
 Program                                                Program
    \                                                   /
  Catnet Module         Catnet Module         Catnet Module
        \                 /       \                /
        LNI-1          LNI-1      LNI-2         LNI-2
           \           /             \          /
          Local Network 1           Local Network 2



Transmission Path

Figure 2
~~~

## Function Description
The function or purpose of Catnet Protocol is to move datagrams through an interconnected set of networks. This is done by passing the datagrams from one Catnet module to another until the destination is reached (via alias routing). The Catnet modules reside in hosts and gateways in the Catnet system. The datagrams are routed from one Catnet module to another through individual networks based on the interpretation of an Catnet address. Thus, one important mechanism of the Catnet protocol is the Catnet address.

In the routing of messages from one Catnet module to another, datagrams may need to traverse a network whose maximum packet size is smaller than the size of the datagram. To overcome this difficulty, a fragmentation mechanism is provided in the Catnet protocol.

### Addressing
A distinction is made between names, addresses, and routes. A name indicates what we seek. An address indicates where it is. A route indicates how to get there. The Catnet protocol deals primarily with addresses. It is the task of higher level (i.e., host-to-host or application) protocols to make the mapping from names to addresses. The Catnet module maps Catnet addresses to local net addresses. It is the task of lower level (i.e., local net or gateways) procedures to make the mapping from local net addresses to routes.

Addresses are fixed length of 32 octets (256 bits). The first 42 bits are for galaxy idenification, then 42 bits for solar-group identification, followed by 42 bits for solar systems. After that, comes 12 bits for planets, then 64 bits for which plantary head. Finally, we have 52 bytes decicated to which participant. The reason for created CP "segments" based off of large, inter-planetary scales, is because sooner rather than later, humanity will have a space travel explosion. A large CP with segments decicated to galaxy scales and smaller is required to make sure that we never run out of CP address. It is also required because of huge transmission times between large distances. For example, a protocol to sync data won't speed lots of energy trying to communicate with heads billions (or more) miles away.

Care must be taken in mapping Catnet addresses to local net addresses; a single physical host must be able to act as if it were several distinct hosts to the extent of using several distinct Catnet addresses. Some hosts will also have several physical interfaces (multi-homing).

That is, provision must be made for a host to have several physical interfaces to the network with each having several logical Catnet addresses.

### Fragmentation
Fragmentation of an Catnet datagram is necessary for every datagram, as it prevents spying on the type of internet traffic. This is required because one of CPv0's main focuses is security and anonymity.

An Catnet datagram can be marked "don't fragment." Any Catnet datagram so marked is not to be Catnet fragmented under any circumstances. If Catnet datagram marked don't fragment cannot be delivered to its destination without fragmenting it, it is to be discarded instead.

Fragmentation, transmission and reassembly across a local network which is invisible to the Catnet protocol module is called catranet fragmentation and may be used, as in the fact the only method to be tested for CPv0 due to lack of funds.

The Catnet fragmentation and reassembly procedure needs to be able to break a datagram into an almost arbitrary number of pieces that can be later reassembled. The receiver of the fragments uses the identification field to ensure that fragments of different datagrams are not mixed. The fragment offset field tells the receiver the position of a fragment in the original datagram. The fragment offset and length determine the portion of the original datagram covered by this fragment. The more-fragments flag indicates (by being reset) the last fragment. These fields provide sufficient information to reassemble datagrams.

The identification field is used to distinguish the fragments of one datagram from those of another. The originating protocol module of an Catnet datagram sets the identification field to a value that must be unique for that source-destination pair and protocol for the time the datagram will be active in the Catnet system. The originating protocol module of a complete datagram sets the more-fragments flag to zero and the fragment offset to zero.

To fragment a Catnet datagram, an Catnet host creates two new Catnet datagrams and copies the contents of the Catnet header fields from the long datagram into both new Catnet heads. The data of the long datagram is divided into two portions on a 8 octet (64 bit) boundary (the second portion might not be an integral multiple of 8 octets, but the first must be). Call the number of 8 octet blocks in the first portion NFB (for Number of Fragment Blocks). The first portion of the data is placed in the first new Catnet datagram, and the total length field is set to the length of the first datagram. The is-fragments flag is set to one. The second portion of the data is placed in the second new Catnet datagram, and the total length field is set to the length of the second datagram. The is-fragment flag is also set here. The fragment offset field of the second new Catnet datagram is set to the value of that field in the long datagram plus NFB.

Unlike fragmenting protocols, in say, IPv4, Catnet sends fragmented network packets whenever allowed, and always send at the same time. This means they do not get sent one by one.

This procedure can be generalized for an n-way split, rather than the two-way split described.

To assemble the fragments of an Catnet datagram, an Catnet protocol module (for example at a destination host) combines Catnet datagrams that all have the same value for the four fields: identification, destination, and protocol. The combination is done by placing the data portion of each fragment in the relative position indicated by the fragment offset in that fragment's Catnet header. The first fragment will have the fragment offset zero, and the last fragment will have the more-fragments flag reset to zero.

# Specification

## Header format
Testing!
