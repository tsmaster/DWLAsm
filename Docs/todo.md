TODO
====================


command-line arguments
----------------------------------------

options for
 - out filename (overwrites .OUT value, if any)


workflow / quality of life
----------------------------------------
script to make blank DSK

script to copy OBJ output into DSK


offsets
----------------------------------------
Verify all the various addressing modes, like that weird (foo,X) mode



regression
----------------------------------------
assemble the whole book with one command, to verify that everything
works

verify that build completes without errors

keep a "golden" listing that is verified against the book,
automatically verify that the current output of the assembler matches
the golden file.

show a completed checklist, showing each ASM file by name, collected 
into chapters. For each file, indicate if it assembles w/o errors, and
if it matches "golden" listing files. If no golden listing file exists,
indicate this, as well.

include directive
----------------------------------------
Allow programmers to include files

"whole buffet" / alphabet / rainbow program
----------------------------------------
What if I wrote a program that hit every opcode? There's fewer than 256
instructions, this can't be that hard. The code wouldn't have to do 
anything useful, it'd just have to be able to cover the full instruction 
space.

