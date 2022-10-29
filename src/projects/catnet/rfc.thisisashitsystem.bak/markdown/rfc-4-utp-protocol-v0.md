UTP Version 0 (UTPv0)

# Introduction
The Uncontrolled user-datagram Transmission Protocol (UTP) is defined to transport datagrams over a network. The underlying protocol is assumed to be the CP protocol (residing on layer 3).

UTP is a protocol that resides on the transport layer. As such, it is used to send datagrams from program to program. The protocol provides no protection or security besides the mandatory checksum (discussed in the specification). If an application needs ordered and reliable data, use another protocol such as the Advanced Transmission Protocol (ATP).

In reality, UTP is an unreliable datagram transmission mechanism but lays the foundation for other transport protocols. UTP is a protocol that deals with ports, and that is it. It can be used for data transmission, or another protocol can take advantage of the base functionality that it already provides.

## Motivation
A protocol that is capable of transmitting sizeable data over CP. 

## Scope
This protocol sits directly on top of CP. Below its own header either resides the header of another application/transport layer protocol or a datagram itself.

## Interface
UTP is the only transport protocol (capable of supporting an application protocol) that sits directly on top of CP. Every other transport protocol (capable of supporting an application protocol) relies on UTP.

# Specification

## Base Header Format
The following is a simple diagram showing the makeup of the UTP protocol.

~~~
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      See HHS                      |  Padding  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           Datagram Length             |        Reserved       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

| Field | Bits | Description | RFC |
| :---- | :--: | :---------: | --: |
| Source Port | 16 | The originating port, except for in alias routing. | N/A |
| Destination Port | 16 | The destination port. | N/A|
| Datagram Length | 20 | The length of the datagram. | N/A |

### See HHS
See RFC 9.

### Source Port
The port that this packet was sent from.

If this packet was sent encapsulated in a CP packet with alias routing enabled, this source port should be set to the port that the alias is listing to.

### Destination Port
The port that this packet should be sent to once it reaches its target destination.

### Datagram Length
The length of everything else, including the complimentary headers.

## Extensibility
As mentioned earlier/above, UTP is the only transport protocol (capable of supporting an application protocol) that sits directly on CP. This would be a problem since UTP provides no data reliability if it was not for the intended extensibility of UTP. Remember that UTP follows the header hierarchy system (HHS, 9).

Each UTP complimentary header is defined in its own RFC. Below is a list.

| Name | RFC |
| :--- | --: |
| ATP  | 5   |

# Reference

1. Catnet RFC 5
2. Catnet RFC 9
3. Catnet RFC 1
4. Internet RFC 768

# Authors
Milo Banks
