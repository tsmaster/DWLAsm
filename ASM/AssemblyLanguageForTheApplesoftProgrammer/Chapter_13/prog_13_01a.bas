
 10  REM  SORT RANDOM NUMBERS
 20  REM  BY LINKING TO MACHINE LANGUAGE ROUTINE
 30  REM  LOADED AT $300
 60  D$ =  CHR$ (4): REM  CTRL-D
 70  PRINT D$;"BLOAD PROG_13_01.OBJ"
 80  PRINT "HOW MANY ELEMENTS?"
 90  INPUT N
 100  N = N - 1
 110  DIM F(N)
 120  PRINT "THE RANDOM NUMBERS WILL BE CALCULATED"
 130  PRINT "ACCORDING TO:"
 140  PRINT 
 150  PRINT "  X = R + S * RND(J)"
 160  PRINT "  F(I) = INT(X)"
 170  PRINT 
 180  PRINT " INPUT J, R, S"
 190  INPUT J,R,S
 200  PRINT 
 210  PRINT "THE LIST"
 220  FOR I = 0 TO N
 230  X = R + S *  RND (J)
 240  F(I) =  INT (X)
 250  PRINT I + 1;".  ";F(I)
 260  NEXT I
 270  REM 
 280  REM  ESTABLISH THE & VECTOR
 290  REM 
 300  POKE 1013,76
 310  REM 
 320  REM  ESTABLISH THE & LINK ADDRESS
 330  POKE 1014,00
 340  POKE 1015,03
 350  REM  LINK TO THE ROUTINE
 360  & F(2)
 370  REM 
 380  PRINT 
 390  REM 
 400  REM  PRINT THE SORTED LIST
 410  REM 
 420  PRINT "THE SORTED LIST:"
 430  FOR I = 0 TO N
 440  PRINT I + 1;".  ";F(I)
 450  NEXT I
 460  REM 
 470  REM  NOW CONSTRUCT THE
 480  REM  FREQUENCY DISTRIBUTION
 490  REM 
 500  PRINT 
 510  PRINT "THE FREQUENCY DISTRIBUTION"
 520  L = 0
 530  C = 0
 540  PC = 1
 550  FOR R = L + 1 TO N - 1
 560  IF (F(L) <  > F(R)) GOTO 590
 570  C = C + 1
 580  NEXT R
 590  PRINT PC;".  ";F(L);"  ";C
 600  L = R
 610  C = 1
 620  PC = PC + 1
 625  IF L+1 >= N GOTO 640
 630  GOTO 550
 640  END


