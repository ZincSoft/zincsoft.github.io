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
A communication facility or medium over which nodes can communicate at the link layer, i.e., the layer immediately below CPv0. Examples are Ethernets (simple or bridged); PPP links; X.25, Frame Relay, or ATM networks; and Catnet-layer or higher-layer "tunnels", such as tunnels over CPv0 itself.

### Neighbors 
Nodes attached to the same link.

### Interface
A node's attachment to a link.

### Address
An identifier for an interface or a set of interfaces.

### Packet
An header, complimentary headers, and payload.

### Link MTU
The maximum transmission unit, i.e., maximum packet size in octets, that can be conveyed over a link.

### Path MTU
The minimum link MTU of all the links in a path between a source node and a destination node.

### Complimentary Header
A header located beneath that of the overarching protocol of the datagram. This does not include the header that belongs to an application/transport layer protocol.

### Alias Routing
A routing technique that improve opon onion routing in terms of speed and security (since we are not bound by the restrictions of the Internet Protocol). Alias routing takes two forms.

#### Mono Aliasing
The original sender tells a single alias node that they should act as an alias. The alias node acts as both the entrance and exit nodes. The single alias node obviously knows who the sender is and who the recipient is, but:

1. Alias nodes change often.
2. Communication between sender and destination is encrypted (most likely, maybe forced).

#### Dual Aliasing
The original sender tells two alias nodes that they should act as aliases. One alias node acts as an entrance node (from the perspective of the destination), and the other one acts as an exit node (with the same perspective). 

## Motivation
The Catnet Protocol is designed for use in interconnected systems of packet-switched computer communication networks. Such a system has been dubbed Catnet. The Catnet Protocol provides for transmitting blocks of data called datagrams from sources to destinations, where sources and destinations are hosts identified by fixed length addresses. The Catnet Protocol also provides for fragmentation and reassembly of large datagrams in order to parallelize the process of exchange.

## Scope
The Catnet Protocol is specifically limited in scope to provide the functions necessary to deliver a package of bits (an Catnet datagram) from a source to a destination over an interconnected system of networks. There are no mechanisms to augment end-to-end data reliability, flow control, sequencing, or other services commonly found in host-to-host protocols. The Catnet Protocol can capitalize on the services of its supporting networks to provide various types and qualities of service.

## Interfaces
This protocol is called on by host-to-host protocols in an Catnet environment. This protocol calls on local network protocols to carry the Catnet datagram to the next gateway or destination host.

For example, a ATP module would call on the Catnet module to take a ATP segment (including the ATP header and user data) as the data portion of an Catnet datagram. The ATP module would provide the addresses and other parameters in the Catnet header to the Catnet module as arguments of the call. The Catnet module would then create an Catnet datagram and call on the local network interface to transmit the Catnet datagram.

## Operation
The Catnet protocol implements two basic functions: addressing and fragmentation.

The Catnet modules use the addresses carried in the Catnet header to transmit Catnet datagrams toward their destinations. The selection of a path for transmission is called routing.

The Catnet modules use fields in the fragmentation header to fragment and reassemble Catnet datagrams when necessary for transmission.

The model of operation is that an Catnet module resides in each host engaged in Catnet communication and in each gateway that interconnects networks. These modules share common rules for interpreting address fields and for fragmenting and assembling Catnet datagrams. In addition, these modules (especially in gateways) have procedures for making routing decisions and other functions.

The Catnet protocol treats each Catnet datagram as an independent entity unrelated to any other Catnet datagram. There are no connections or logical circuits (virtual or otherwise).

The Catnet protocol does not provide a reliable communication facility. There are no acknowledgments either end-to-end or hop-by-hop. There is no error control for data, only a header checksum. There are no retransmissions. There is no flow control.

Errors detected may be reported via the WUPS which is implemented in the Catnet protocol module.

## Relation to other protocols
The following diagram illustrates the place of the Catnet protocol in the protocol hierarchy:

~~~
+--------+ +------+ +------+ 
| Saynet | | RFTP | | UFTP |
+--------+ +------+ +------+
        |   |          |
       +-----+      +-----+
       | ATP |      | UTP |
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
Addresses are fixed length of 16 octets (128 bits). Each range of bits has a specific part to play. See the simple diagram below. Please note that the top layer is the tens place in the number of octets, the second layer is the ones place in the number of octets (forming one number with layer one), and the bottommost layer is just bites.

You may notice how similar this is with IPv6 addresses. In fact, they are the same. We don't need to include anything special for the CP protocol, so the CP protocol uses a tried and proven method.

~~~
                          1 1 1   1 1 1 1
 0  1 2 3 4   5 6 7 8   9 0 1 2   3 4 5 6
 0 8 6 4 2 0 8 6 4 2 0 8 6 4 2 0 8 6 4 2 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| Global Prefix | S |   Interface ID    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

#### Global Prefix (Global Routing Prefix)
A value assigned to a site, which is a cluster of subnets.

#### S (Subnet)
A division of a network into two or more networks. In other words, a logical division of a CP network.

#### Interface ID
An identifier referring to a particular node.

### Fragmentation
Unlike some other protocols (outside of Catnet), fragmentation of an Catnet datagram is not necessary for every datagram. It would provide minimal security benefit, and make the entire system slower.

An Catnet datagram can be marked "don't fragment." Any Catnet datagram marked so is not to be fragmented under any circumstances. If a datagram marked as don't fragment cannot be delivered to its destination without fragmenting it, it is to be discarded instead. The error will then be reported via WUPS.

The Catnet fragmentation and reassembly procedure needs to be able to break a datagram into an almost arbitrary number of pieces that can be later reassembled. The receiver of the fragments uses the identification field to ensure that fragments of different datagrams are not mixed. The fragment offset field tells the receiver the position of a fragment in the original datagram. The fragment offset and length determine the portion of the original datagram covered by this fragment. The more-fragments flag indicates the last fragment. These fields provide sufficient information to reassemble datagrams.

The identification field is used to distinguish the fragments of one datagram from those of another. The originating protocol module of a datagram sets the identification field to a value that must be unique for that source-destination pair and protocol for the time the datagram will be active in the Catnet system. This identifier must remain unique for a reasonable amount of time (exceeding the likely lifetime for a fragment stream). The originating protocol module of a complete datagram sets the more-fragments flag to zero and the fragment offset to zero.

The sender and the receiver are the only two entities that play a part in fragmentation. Every other system (such as a head) is oblivious, and delivers the packet without understanding.

Fragmented network packets should be sent without awaiting confirmation from the destination as this would be inefficient, and no protocol nor method currently exists for this purpose.

To assemble the fragments of an Catnet datagram, a Catnet protocol module (for example at a destination host) combines Catnet datagrams that all have the same value for the four fields: identification, sender, destination, and protocol. The combination is done by placing the data portion of each fragment in the relative position indicated by the fragment offset in that fragment's Catnet header. The first fragment will have the fragment offset zero, and the last fragment will have the more-fragments flag reset to zero.

# Specification

## Base Header Format
The following is a simple diagram showing the makeup of the CPv0 header.

~~~
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| Version |   T   |          Payload Length       |H|A| Padding |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|    Hop Limit    |                 Future Use                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                                                               +
|                                                               |
+                    Destination Address                        +
|                                                               |
+                                                               +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                                                               +
|                        Sender Address                         |
+               (may be used for alias routing                  +
|                 if no sender is supplied)                     |
+                                                               +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

| Field | Bits | Description | RFC |
| :---- | :--: | :---------: | --: |
| Version | 5 | The version of the CP protocol. | N/A |
| T | 4 | The traffic class for priority specification. | N/A |
| Payload Length | 16 | The length of everything below this header.| N/A |
| H | 1 | Is there a header below this one? | N/A |
| A | 1 | Is alias routing enabled? | N/A |
| Hop Limit | 9 | The number of times this packet can be forwarded. | N/A |
| Destination Address | 128 | The destination of the packet (ish). | N/A |
| Sender Address | 128 | The sender of the packet. Optional with alias header. | N/A |

### Version
This field should stay the same across every CP protocol revision/version. Instead of a single bit referring to the version (making only 5 possible), this is interpreted as a number in binary form (16 possible). The version number in the header matches the version of the protocol (0 is 0, 1 is 1, etc...).

### Traffic Class (T)
Specifies the quality of service that is desired. Each bit depicts the requested quality of a certain aspect of the network (0 being normal and 1 being high).

| Bit | Description              |
| :-- | ----------:              |
| 0   | Must be 0. Sanity check. |
| 1   | Throughput               |
| 2   | Delay                    |
| 3   | Reliability              |

As mentioned, bit 0 must be 0. This serves as a very basic (and most likely useless) sanity check. It is up to the implementation on whether to implement this, because it isn't strictly required.


### Payload Length
The length of all the data contained underneath the CP header. Includes the complimentary headers.

### More Headers (H)
More headers is a one bit field denoted by the letter H. 0 means there are no more complimentary headers, and 1 means the opposite.

### Alias Routing Enabled (A)
Is this bit is set to 1, the sender field is treated as the alias header.

### Hop Limit
The number of times that a packet should be relayed through a node. This number should be decremented by one for every hop, and once this number reaches 0 it should be discarded

## Alias Header Format

## Header Type Identifier
This header uses a header type identifier that is equal to the number 1 (00000001). See "Header Type Detection".

## Alias Header Format
The following is a simple diagram showing the makeup of the alias header. Unlike every other header, this one goes in the sender field of the CP header if the A bit is set to 1.

~~~
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      See HHS                      | Alias Pos |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                                                               +
|                                                               |
+                        Alias Address                          +
|                                                               |
+                                                               +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
+                     Verification Token                        +
|                                                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

| Field | Bits | Description | RFC |
| :---- | :--: | :---------: | --: |
| Alias Pos | 6 | The position of the alias. | N/A |
| Alias Address | 128 | CP address of the alias. | N/A |
| Verification Token | 64 | A verification token. | N/A |

### See HHS
See RFC 9.

### Alias Position (Alias Pos)
The position of the alias. Below is a table explaining the meaning of each bit.

| Bit | Description |
| :-- | ----------: |
| 0 | Type of alias routing. |
| 1 | Entrance alias node. | 
| 2 | Exit alias node. |
| 3-4 | Reserved |

#### Bit 0: Type of alias routing
Set to 0, this means that mono alias routing is in effect. Vice versa, when the bit is set to 1 it means that dual alias routing is being used.

### Alias Address
The CP address of the alias. Since this packet is sent to the destination, they have no idea who actually sent the packet, and are forced to send to the alias if they want to send it at all. The address that this points to should refer to a head that has been notified of its alias status via the LMK protocol.

### Verification Token
To make sure that no one is sending faulty data, a verification token is used. If the original sender receives a verification token that does not match the one they sent, the data has been tampered with, and should be discarded immediately. This is only really necessary in a non-encrypted environment, as the "man in the middle" wouldn't be able to tamper with the data anyways without knowing the sender's private key.  

## Fragment Header Format
The following is a simple diagram showing the makeup of the fragment header.

~~~
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      See HHS                      |  Padding  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Fragment Offset       |       Stream (srm) Token       ->
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  Srm Token |           Reserved (may be excluded)              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

| Field | Bits | Description | RFC |
| :---- | :--: | :---------: | --: |
| Fragment Offset | 16 | Offset data from original fragment. | N/A |
| Stream Token | 22 | Identifies the fragment stream. | N/A |

### See HHS
See RFC 9.

### Fragment Offset
The offset, in 8-bit octet units, of the data following this header, relative to the start of the fragmentable part of the original header. Because they are measured in 8-octet units, every bit is equal to 8-octet units (1 \* 8 \* 8 = 64). Each fragmentable part of a packet must be a multiple of 64 bits. This means that the maximum size of all the fragment data (once they have been defragmented) is 70464 bits (16 bit max = 65535 -> 65535 \* 8 \* 8 = 4194240). This may seem like a very large maximum stream size, but we might as well put that extra space to good use.

#### Fragmentable Segment vs Unfragmentable Segment
In the above section labeled "Fragment Offset", the term fragmentable segment was used. While this is defined in the vocabulary section, here is a helpful diagram.

~~~
+------------------+----------------------//-----------------------+
|  Unfragmentable  |                 Fragmentable                  |
|       Part       |                     Part                      |
+------------------+----------------------//-----------------------+
~~~

The unfragmentable part includes the complimentary headers, everything after that (everything after the H bit has been set to 0 in the final complimentary header) counts as fragmentable. Each packet has a unfragmentable part and a fragmentable part. Keep in mind that even a packet with a fragment header still has to include other headers, as they are not inherited from the original fragment.

### Stream Token (Srm Token)
A token that must be unique from any other stream token used recently.

"Recently" means within the maximum likely lifetime of a packet including transit time from source to destination and time spent awaiting reassembly with other fragments of the same packet. However, it is not required that a source node know the maximum packet lifetime.  Rather, it is assumed that the requirement can be met by maintaining the Identification value as a simple, 32-bit, "wrap-around" counter, incremented each time a packet must be fragmented.  It is an implementation choice whether to maintain a single counter for the node or multiple counters, e.g., one for each of the node's possible source addresses, or one for each active (source address, destination address)combination.

# References
1. Internet RFC 791

2. Internet RFC 2460

3. Catnet RFC 9

##### **Some text was copied verbatim!**
The only text that was copied were explanations of common networking terms and practices.

# Authors
Milo Banks
