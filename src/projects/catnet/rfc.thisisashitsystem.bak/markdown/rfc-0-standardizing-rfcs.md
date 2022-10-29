Standardizing RFCs

#### Note 1:
Sometimes you may have a note. These should be under a \#\#\#\# header. For example, you could say that this RFC for standardizing RFCs was taken mainly from [here](https://datatracker.ietf.org/doc/html/rfc791#section-1.1) (although this should rather go in the references section).

#### Note 2:
This is what should actually go in a note: information pretaining to the RFC that should we read first. This RFC is a recomendation, and you can bend it or ignore it on a RFC by RFC basis. It acts only as a basic blueprint.

# Introduction
Generally, no text should go beneath &lt;h1&gt; headers (a single \# in markup). This text is only here as an example of what not to do.

A two newlines should seperate all headers, and paragraphs with different content.

## Motivation
A simple overview. What it is used for, why it was designed.

## Scope
What is the scope of this protocol? What OSI layer does it operate on? Is it closely tied to another protocol/RFC?

## Interface
How would this protocol/RFC be used? What other protocols/RFC use it? For example, 

## Operation
How does this protocol/RFC work? Think of it as a more in depth motivation. Provide a high level overview of the protocol/RFC.

# Overview

## Relation to other RFCs
Provide an explanation on simular Protocols/RFCs, and why this one is diferent (or builds opon the other). You may choose to draw a ASCII chart such as the one below:

~~~
+------+ +------+ +------+      +-----+
|Saynet| | OMTP | | UFTP |  ... | ... |
+------+ +------+ +------+      +-----+
      |   |          |             |
     +-----+      +-----+       +-----+
     | ATP |      | UTP |  ...  | ... |
     +-----+      +-----+       +-----+
        |            |             |
      +------------------------------+
      |         Catnet Protocol      |
      +------------------------------+
                     |
        +--------------------------+
        |  Local Network Protocol  |
        +--------------------------+

Protocol Relationships

Figure 1.
~~~

While we are on the topic of code blocks, a code block must be bookended by a newline. You may create one with syntax highlighting like so (the language will be automatically detected):

~~~
/// A simple fizz buzz program.
fn main() {
    for i in 1..102 {
        match (i%3, i%5) {
            (0, 0) => println!("FizzBuzz"),
            (0, _) => println!("Fizz"),
            (_, 0) => println!("Buzz"),
            (_, _) => println!("{}", i)
        }
    }
}
~~~

Keep in mind that we use the `kramdown` markdown parser, so backtick code blocks are not supported. Instead, use tildas (`~`).

## Model of operation
Provide an example of what might happen. Provide some assumptions (e.g. `this transmission will involve one intermediate gateway.`) if needed, and then provide a step by step example of the intercommunication that might occur. You may also provide a diagram to assist.

~~~
Application                                         Application
   Program                                          Program
          \                                        /
       Catnet Module    Catnet Module        Catnet Module
             \            /       \              /
            Local Network 1       Local Network 2

Transmission Path

Figure 2
~~~

## Function description
Provide a description of each of the functions that the protocol preforms. For example, if your protocol is capable of addressing and fragmentation, you might have an addressing and fragmentation section explaining in detail what these do.

# Specification
This is where you provide the really in depth analysis, and actually provide implementation details.

# References
Place any reference here. This may reference an outside website, or another RFC/protocol.

# Authors
The author. In this case, Milo Banks.
