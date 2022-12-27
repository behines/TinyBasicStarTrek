# TinyBasicStarTrek
Star Trek in Tiny Basics for the Altaids 8085 kit computer

See https://www.nutsvolts.com/magazine/article/build-a-pocket-sized-altair-computer for information on the 
computer.  At present, Nuts & Volts is out of stock of the kits, but I've seen them elsewhere online, or 
you can use David Hunter's Eagle files to make your own.

The main code file is very hard to read because I was working hard to make it fit into 8K of RAM.  The 
code was adapted from a listing by Brian Denley at https://groups.io/g/ET-3400/topic/88950752#2212, for 
the Heathkit ET-3400.  After I got started, I came to learn that the initial listing had numerous bugs
which were fixed later.  The final version was uploaded to the ET-3400 group's project archives, but
the final results had numerous hard dependencies on the ET-3400 (e.g. USR() calls) and thus was not
usable.

I started to dissect and comment the original code; that is the "Annotated" file.  This file is *not*
a copy of the actual working code, but is pretty close and will guide the reader.

One of the things I did with my version was to shorten the line numbers by removing the final 0.  This
saves hundreds of bytes.

I also removed virtually all spaces, and I used keyword abbreviations (e.g. "R." for "RETURN") whereever
possible.
