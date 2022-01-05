Header Hierarchy System (HHS)

# Introduction
Deviating from the internet protocols, the Catnet protocols try to reduce the number of protocols instead of following the DRY principle more closely. Take UDP and TCP as an example. They both have duplicated fields and can share code, not to mention performing the same task. Why have two protocols when one will suffice?

The Header Hierarchy System (HHS) specifies complimentary headers and how they are integrated.

## Vocabulary

### Header
"Metadata" that goes at the beginning of a protocol.

### Complimentary Header
A header that compliments a base one and provides optional information. For example, ATP is a complimentary header to UTP because ATP specifies optional more information.

### DRY
"Don't repeat yourself."

> The DRY principle [states], "Every piece of knowledge must have a single, unambiguous, authoritative representation within a system." The principle has been formulated by Andy Hunt and Dave Thomas in their book The Pragmatic Programmer. They [broadly apply it] to include "database schemas, test plans, the build system, even documentation." When the DRY principle is applied successfully, a modification of any single element of a system does not require a change in other logically unrelated elements. Additionally, [logically related elements] all change predictably and uniformly and are thus kept in sync.

-- [Wikipedia](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

## Motivation
Instead of specifying these same rules inside each RFC that takes advantage of this functionality, a new RFC was created not to repeat ourselves. Fitting, isn't it?

## Scope
The HHS system applies to every RFC that seeks to take advantage of it, so long as it is a protocol and is capable of doing so.

# Specification

### Base Header Fragment Format
The following is a simple diagram showing the fragment that every HHS compatible header needs to follow.

~~~
 0                   1                   2
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| Type Identifier |           Checksum            |H|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~~~

#### Type Identifier
This 9-bit number is unique for every HHS compliant protocol.

#### Checksum
This checksum is created with this header and all the data below it. In this case, data may refer to another header (complimentary) or just a datagram.

The checksum is calculated as follows: the checksum field is the 16-bit ones' complement of the ones' complement sum of all 16-bit words in the header. For purposes of computing the checksum, the value of the checksum field is zero.

#### H (Next Header)
A single bit specifying if there is another complimentary header after this one. If not, expect a datagram.

# Authors
Milo Banks
