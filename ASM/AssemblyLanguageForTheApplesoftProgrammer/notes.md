# Notes

As mentioned in my story doc, "Assembly Language for the Applesoft
Programmer" was and is a book that is important to me - setting me on
a quest to learn 6502 assembly language, specifically for the
Apple ][. I wanted to learn those skills to become a game
developer. This book turns out not to offer a huge amount of game dev
insights (perhaps I will have other directories here that get closer
to that).

This directory contains my ASM files that either transcribe listings
from the book, or are my solutions to the various exercises through
the book.

I will also add comments and errata in this document to provide my
thoughts as I take another pass through this book.


## Errata

### Chapter 2, Page 26

Towards the end of the program, line 1140, there's an INX instruction
that ought to be followed by DEY. Insert that before the BPL LOOP
instruction, and the code should work.

Note that the generated BPL offset is now 0xF6 instead of 0xF7 as
printed in the book.



