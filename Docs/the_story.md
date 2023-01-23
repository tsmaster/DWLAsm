The Story
====================

I have been telling versions of this story off and on for a while, and
I suspect I've told several people the same story more than once. It
stretches out over many years, and I feel like it's currently turning
in a narratively satisfying direction.

Part I: The Early Years
----------------------------------------
When I was a kid, I had an Apple ][, and it was something I knew was
going to be a big part of my future. I learned to program in BASIC on
the machine, I played a bunch of computer games on it, and I aspired
to write my own computer games. I could tell that there was a gap
between the programs I wrote in BASIC and the professional (8 bit,
rudimentary to a modern (2023) viewer) games I enjoyed playing.

One big difference was that my BASIC programs had nowhere near the
speed, the quality, the interactivity of professional works. And I
could see that the pros didn't program in BASIC. Somehow, through
magazines, through other sources (what other sources were there back
then?), I came to understand that Assembly Language was how the pros
wrote cool software. I intended to learn Assembly Language somehow.

![image](https://user-images.githubusercontent.com/72338/213951605-b34f5516-0e68-491f-aef2-b2401578d7f8.png)

Some time in the early 80s, my family and I took a road trip to visit
the Pacific Science Center in Seattle (a day trip, took a few hours
each way). The gift shop had a wide variety of what, today, I'd call
STEM books, not all slanted towards kids. There were books on
architecture, including coffeetable books by the likes of Buckminster
Fuller (then popularizer of the geodesic dome, today the namesake of
"Buckyball" carbon molecules). I'm sure that "Godel, Escher, Bach" was
for sale there.

Also, a book titled "Assembly Language for the Applesoft Programmer",
by C. W. Finley, Jr. and Roy E. Myers. If there's going to be a movie,
this is the time when we play sound effects of an angel choir and a
ray of light from heaven - this seemed like exactly the key that would
unlock the gate that kept me from being the game developer I aspired
to be. This was my golden ticket.

The suggested retail price on the back of the book is $16.95. I did
not have a paper route, I did not have an after-school job. I did not
have much of an allowance. I did not have $16.95. I begged my father
to buy me the book, because it would be educational, it would teach me
important lessons. He flipped through the book, saw that there were
programs, there were exercises - it seemed like it was a worthwhile
purchase, but he made me promise that if he bought me the book, that I
would type in the programs, I would get them running, I would do the
exercises.

Hand to God, yes, Dad, I will type in the programs, I will get them
running, I will do the exercises. I will learn the lessons that the
book has to teach me.

Which was all well and good until I got to the end of chapter 1, where
it says that I really needed a "fully implemented assembler", going on
to mention

 - S-C Assembler
 - BIG MAC
 - LISA (pronounced LI ZA, for some reason)

All of which were well beyond my budget. I was disappointed that this
path to interactive graphic displays and action games was still closed
to me.

The book went on the shelf, not entirely forgotten, but not useful to
me.

I went off to college, studied computer science, learned a number of
programming languages, including the assembly language of the 64-bit
DEC Alpha, which reminded me of the promises I had made to my dad. I
had an opportunity to learn from Hal Abelson, one of the authors of
Apple LOGO. I graduated, and eventually ended up with a career in game
development, so things pretty much worked out for that kid who wanted
to learn assembly language.


Part II: Virtual Satisfaction
----------------------------------------
At some point in the early 2000s, some twenty-ish years after the
promise I made to my father, computers were much faster, development
environments were easy to come by, I had a fancy Linux desktop
environment with multiple big screens. It occurred to me that I could
use a piece of software to emulate the behavior of an Apple II. I
discovered that the S-C Assembler that I couldn't afford as a kid was
now being distributed for free, with the author's approval, on the
Internet.

I pulled the book on Assembly Language for the Applesoft Programmer
off the shelf, blew off the strata of dust that had accumulated, and
set to seeing if I could make any progress on the lessons that it
wanted to teach me.

I discovered that I had become used to a lot of modern conveniences,
including those big screens. Programming environments had windows,
menus, and mouse interfaces. The S-C Assembler system was challenging
to use in comparison - it ran on the Apple ][, and was limited by the
40-column, 24 row display of the Apple ][, as well as the 140k floppy
disk drives. Even in emulation, these limits remained.

Nevertheless, I proceeded through the chapters. I learned about the A,
X, Y, P and S registers. I learned about the overflow, carry,
interrupt flags. I understood about zero-page memory, the lowest 256
bytes of the Apple's 64 kilobytes of memory (if you were privileged
enough to have installed the full complement of memory available to a
16-bit address bus).

There was some discussion in the book about the implementation of
graphics on the Apple ][, with 7 pixels per byte, and 8, no, 6 colors,
on the high-res graphics screen, except that you could only put
certain colors together, because the 8th bit in the byte selected a
palette of four colors, sort of, so you could put green and purple
near each other, you could not put orange and green next to each
other. But, also, you couldn't put green and purple RIGHT next to each
other, because green was accomplished by lighting up pixels in odd
columns, and purple was accomplished by lighting up pixels in even
columns. If you drew an odd and an even pixel next to each other, you
got white. It all makes more sense if you understand the chroma burst
channel of NTSC color television.

Also, the high res screen of the Apple ][ had some curious quirks to
it, including the mapping of memory addresses to (x,y) coordinates on
the screen. It's not super important to go into here, but if you
filled in bytes in memory, you'd discover that stripes of memory did
not lead to contiguous parts of the screen, instead jumping from the
top of the screen to a third of the way down, to 2/3 of the way down,
then back up to near the top, where the jumps continued.

The book had some information about drawing graphics, but not a lot,
and what was in the book wouldn't have been sufficient for a young
version of myself to make a compelling action game - so maybe I was
just as well to have gone to learn game development elsewhere.

I finished the lessons in the book, I found bugs in the programs, I
got them working. I decided to give myself one capstone challenge, to
draw a Mandelbrot Set fractal on the high-res screen. As I described
above, graphics on the Apple ][ comes with challenges. Additionally,
the 6502 processor does not natively support floating point
numbers. Or even multiplication or division. So, there was some work
to do.

I ran into a few issues along the way - I was able to get something
fractal-ish drawing relatively quickly, but I had difficulty debugging
the math - I translated my assembly language code back into BASIC, and
verified that my logic was sound. I discovered that there was an
overflow flag that I hadn't been paying attention to that was
important for the correct calculation of the math. Once I fixed that
bug, I had a Mandelbrot Renderer running in assembly. I also had a
BASIC implementation of essentially the same program. If I recall
correctly now, the assembly version ran around three times as fast,
the code was maybe three times as many lines, and it took me about ten
times as long to get the assembly version working, compared to the
version coded in BASIC.

![image](https://user-images.githubusercontent.com/72338/213951521-09ee72b5-2197-4313-9148-ed47c725e024.png)


I had proven that I had learned the lessons, I was an Apple II
assembly language programmer, even though the Apple II was decades out
of date already at that time. I printed out screenshots of my
Mandelbrot renders, and showed them to my father. He did not recall
the promise I had made to make my way through the book. He was not
impressed by 280x192 pixel blocky renders of fractal geometry. He
hadn't been waiting for me to make good on my promise - that was all
only in my head. Still, even if it was just me that was keeping track,
I was satisfied that I had finally finished the task.


Part III - Another time around
----------------------------------------
To some degree, the story has an ending with me finishing the book,
back in 2004 or so. I put the book aside, I had little use for chunky
graphics and outdated processors.

Still, things come around, and I find myself drawn back to what now
consists of low-res simple presentations. I was one of a community who
crowdfunded a new 8-bit computer roleplaying game that runs on the
Apple ][. I watch YouTube videos of people programming, including
people trying to make sense of the Apple ]['s many quirks.

I have a number of projects which include a few ideas for things I
want to do that are in some way related to the Apple ][. I have even
more books now that talk about ways to get flicker-free graphics using
assembly language techniques.

It has occurred to me that a thing that I would like is to be able to
use a modern(?) editor like Emacs, a modern Operating System like
Linux, and write code with niceties like being able to cut and paste,
or use the up and down arrow keys.

There are tools out there that pretty much do this, including ca65 and
several others. As far as I've been able to determine, these tools
tend to not focus on the 8-bit 64k 6502 Apple ][, instead either spreading
their focus horizontally to other 8-bit 6502 machines, like the
Commodore 64 and the Atari 400, or instead going on to the 16-bit
65816 chip found in the Apple IIgs. There's still interesting bits of
retro tech there, but the limited space of the Apple ][ calls to me.

The idea has occurred to me that an assembler is not a super
complicated program to write. The 6502 processor has a surprising
number of different ways to access memory, but it's still an 8-bit
machine, so how hard could that be to support?

As I write this, I have had my first success - I have taken a very
simple example program - only 10 lines long in its source code
representation. I have written a Python script that interprets these
instructions, translating them into 24 bytes of Apple ][ 6502 machine
code. I took this 24-byte program, installed it onto a disk image
file, which I opened up using the Apple ][ emulator program. The
virtual Apple ][ loaded my program and executed it - changing the
display to the high-res graphics screen and clearing it to white.

It's satisfying to have my assembler generate a program that
runs. It's a second level of deeper comprehension of what the book had
been trying to convey back then.

And it's satisfying to, if for nobody else but me, build the tool that
I wish I had at my disposal back when I first opened that book.



As of the time of writing this, the assembler supports maybe half of
the opcodes of the 6502. It does not handle labels at all, which was
one of the compelling reasons to buy a professional assembler back in
the 80s.

I've considered features that modern compilers have (constant folding,
loop unrolling), but I think those are out of scope for a 6502
assembler. I could put a little work into making the workflow a little
more convenient. I'm sure that there are error-handling features that
I'm going to want, if I use this assembler for anything more than
simple toy problems.
