RFC 2:<br/>CIP Protocol for Others Discovery (CIPPODv0)

# Introduction

## Terminology

### Node
A CIPPODv0 capable device. Typically a Catnet enabled router.

### Others
A plural for nodes, neighbors.

## Motivation
The CIP Protocol for Others Discovery version zero (CIPPODv0, pronounces Kip-odd-vuh-zee-ro) is designed for use in interconnected systems of packet-switched computer communication networks as an application layer protocol. Such a system is the Internet (but not Catnet in this case).

The CIPPODv0 protocol provides a service for one node to discover a other nodes. Typically, all nodes will know of at most 2^12 other nodes. This means, idealy, each node will know of 4096 other nodes, however more can be known.

## Scope
The CIPPODv0 protocol is specifically limited in scope in providing the functions nessisary to discover other nodes. It does not have any mechanisms for performing connection handshakes, nor does it provide a way to send any actual data. This should be left to other protocols in the same Applicaiton layer.

## Interfaces


