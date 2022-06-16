CNMP Version 0 (CNMPv0)

# Introduction
The CNMP (Catnet Non-application Message Protocol) protocol is used as a device for sending information and error messages from a sender to a receiver. The data transmitted through this protocol is not necessarily useless to the end-user, only the Catnet module that underlies it. It should not be used to transmit data relevant to the user without *excellent reason* (and instead should go over an transport layer protocol such as ATP/UTP).

This protocol is used for denoting errors (such as if a host could not be reached or if a service is unavailable) and sending/broadcasting information and requests. Such requests may be an echo request (a ping/request) or a router broadcast (information).

## Terminology

### Error
An error was encountered trying to fulfil another protocol (excluding CNMP). *A CNMP error should never be sent as a response to a CNMP error*

### Information Request
Information (information in the form of the CNMP protocol) that requests information.

### Information Send
Information is sent in response to information (from any protocol, including CNMP).

## Motivation
CNMR is a protocol that uses CP intending to deliver simple messages about the requested state of the network or the failure of packet routing/delivery.

## Scope
While CNMP technically uses IP, it is used in part to diagnose and describe errors relating to it. For clarity, it is described as being on the network layer.

CNMP is very closely tied to the CP protocol (RFC 1).

## Interface
Here are *some* examples concerning the two prominent use cases for this protocol.

### Error Denoting

1. Destination unreachable
2. ATP packet resend request

### Solicited Information Request

1. ATP packet resend request
2. ATP packet faulty token

### Unsolicited Information Request

1. Echo (ping)
2. Router solicitation

### Solicited Information Send

1. Echo Reply
2. Alias relations (incoming)

### Unsolicited Information Send

1. Alias relations (incoming)
2. Echo request (ping request)

# Overview

## Relation to other RFCs

This RFC runs on top of the CP protocol (as mentioned earlier). Typically, for the error reporting part of this protocol, it will be in direct response to another protocol (where that other protocol is not CNMP).

Different RFCs should be written for every code carried inside a CNMP header. For example, the APRR protocol's RFC specifies what code is used to identify it and what extra data should be included (if any).

In short, protocols use CNMP to send back elementary information that is simple enough it does not need its own protocol. It is also used to report errors about the network and failures concerning other protocols.

Below is a list of all the RFCs that use CNMP.

| Name | RFC |
| :--- | --: |
| APRR | 6   |

## Reliability

CNMP provides no promise of reliability. A checksum is provided but is not required to act upon. There is no mechanism for requesting the resending of a CNMP packet, as CNMP is only for sending errors and information (which are not strictly required). As such, these may go undelivered. Any Catnet module that implements CNMP (which all are required to) should have a timeout mechanism (implementation specifics are left up to the implementation).

Because the CP protocol has fragmentation capabilities, CNMP packets should only be sent for the original packet, not subsequent fragments, to avoid packet flooding.

# Specification

## Base Header Format
The following is a simple diagram showing the makeup of the CNMP protocol.

~~~
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      See HHS                      |   Type    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|   Code    |             Port              |       Unused       ->
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                             Unused                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

| Field | Bits | Description | RFC |
| :---- | :--: | :---------: | --: |
| Type | 6 | Class of message. | N/A |
| Code | 6 | Details of class. | N/A|
| Port | 16 | Identifies the fragment stream. | N/A |

### See HHS
See RFC 9.

### Type
A number representing the class of the message.

### Code
A number giving more detail into the class of the message.

### Port
The port that the CNMP packet should be forwarded to. This forwarding is done inside the computer.

### Unused
This may be used to provide extra context. Not required, but the amount of space used here should be kept small; overwise, another protocol should be considered for use.

# Reference

1. Catnet RFC 4
2. Catnet RFC 5
3. Catnet RFC 6
4. Internet RFC 792

# Authors
Milo Banks
