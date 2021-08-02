RFC 1:<br/>CIP Protocol for External Onion Routing v0 (CIPPEORv0)

# Introduction

## Terminology

### Translator
A device that is placed between a non-Catnet enabled router and the connection to the outside world. It translates CIPPEORv0 requests into regular IP packets that the non-Catnet enabled router can handle.

### Node
A device that implements CIPPEORv0. Most likely a translator.

### Node/Translator Router
A node/translator that forwards CIPPEORv0 requests that don't have a final addressed of itself.

### Circuit
A route of nodes that traffic can be passed through.

### Router
An alias for a circuit.

### Onion Layer
A certain layer in onion routing. For example, the first node in the circut would be the first layer, and the last node in the circuit would be the last node.

## Neighbors
A node relative and known to the current node.

## Motivation
The CIP (Catnet IP Protocol) Protocol for Alias Routing (CIPPEORv0, pronounced Kippy-ore vuh zero) is designed for use in interconnected computer networks. More specifically, it is used by translators to route outgoing traffic to other translators, through Onion routing. The CIPPEORv0 Protocol provides a simple mechanism for performing an encryption handshake on a number of parties (to establish a circuit), each one more layered than the last. The CIPPEORv0 Protocol also allows for IP packets (encapsulated with the CIPPP protocol) to be routed through the circuit.

## Scope
The CIPPEORv0 protocol is specifically limited in scope to provide the facility to perform an encryption handshare, establish a route, and pass along CIPPP encapsulated packets through the route.
