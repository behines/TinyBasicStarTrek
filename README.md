# TinyBasicStarTrek
Star Trek in Tiny Basic for the Altaids 8085 kit computer.

See https://www.nutsvolts.com/magazine/article/build-a-pocket-sized-altair-computer for information on the 
computer.  At present, Nuts & Volts is out of stock of the kits, but I've seen them elsewhere online, or 
you can use David Hunter's Eagle files to make your own.

The main code file is very hard to read because I was working hard to make it fit into 8K of RAM.  The 
code was adapted from a listing posted by Brian Denley at https://groups.io/g/ET-3400/topic/88950752#2212, for the Heathkit ET-3400.  After I got started, I came to learn that the initial listing had numerous bugs
which were fixed later.  The final version was uploaded to the ET-3400 group's project archives, but
the final results had numerous hard dependencies on the ET-3400 (e.g. USR() calls) and thus was not
usable.

I started to dissect and comment the original code; that is the "Annotated" file.  This file is *not*
a copy of the actual working code, but is pretty close and will guide the reader.

One of the things I did with my version was to shorten the line numbers by removing the final 0.  This
saves hundreds of bytes.

I also removed virtually all spaces, and I used keyword abbreviations (e.g. "R." for "RETURN") whereever
possible.  The code now fits into the 8K RAM, and there is more wiggle room to be had if need be, as explained further below.




I posted to the ET-3400 group and got a very long and helpful reply from Mark Cummings, who had 
done the port of the code to the ET-3400 and worked through many bugs.  In addition to my annotation
file, Mark has posted his handwritten annotations to the Project files area of the ER-3400 group.



Now for random notes.  On the Altaids machine, the @() array holds 16-bit numbers as expected by the original code.


Mark Cummings had noted a bug fix for line 5980 from the thread on the discussion group, which I have included.

In his follow-up email, Mark provided a hack for getting the quadrant values to fit into 8 bits by swapping M and J.  Since there is never more than one starbase per quadrant, the number will never exceed 200.  I have not yet implemented that change, but that would free up 64 bytes, which is a lot.

Storage could definitely be optimized.  It feels like there might actually be enough memory to remember the entire 64x64 map if one worked hard, so that the sector doesn’t rearrange every time you leave and re-enter..  At 3 bits per sector that would take 1.5 kbytes of RAM.  That could be squeezed to 1K if you don’t require to store the Enterprise’s location in the sector map.  But it would add additional bytes of code to encode and decode it all.  An interesting project for the future.





I could squeeze it a good bit more as well – every time I replace one of the Increment/Test/Goto “DO LOOP” constructs with the FOR/NEXT supported in the Palo Altaids Basic, I pick up about 10 bytes.  I also can continue to combine lines with the “:” character, which eliminates the line number and whatever data structures are used to hold a line.  All in all, I bet I could free up another 500 bytes if need be.

I realized after the fact that I could keep the REM lines in my listing, if I had just deleted the line numbers.  The interpreter would have accepted the input but then just discard it.  It would, however, slow down program load.  I am loading the program by pasting it into my TeraTerm window.  At 2400 baud with the character and line delays mentioned by David Hunter in his article, loading the program is a “start it and walk away” thing for sure.



Like Mark Cummings, I don’t have the INKEY or NAP functions.  I have to read a character string using GET$(), which requires the user to hit Return, no big loss.  GET$() which requires reading into a dimensioned variable.  I chose Q.   But because of the conflict between DIM() and @() in the Palo Altaids Basic, I can’t use DIM.  (I could, but it would require offsetting the start point in the @() array to skip past the region occupied by DIM’med variables.  The workaround, since I only need a single DIM, is to just say “Q=FREE”, which makes Q act like a dimensioned variable that points to the start of free space (sort of like a heap) rather than down from the end.  In essence it’s recoding DIM manually.  Which is fine.  I should check the details of that.  I might need to say “FREE+2” instead of FREE.  

Another mod I had to make was that RND(n) on my machine produces a number from 1..N rather than 0..N-1.  

Palo Altaids Basic doesn’t support “;” characters in PRINT statements.  Instead I had to replace them with commas to use the # character to control field width.  For example, PRINT #3,I says “Print I in a 3-character-wide field”.  The formatting is still a bit klunky in places but acceptable.

I also changed line 740 to say “you were a hero” rather than “you were a good man”.  Saved a few bytes and removed gender bias as well.

I haven’t yet had the problem with the Quadrant generation hang reported by Mark Cummings, but I haven’t played more than an hour total probably.  Maybe my Basic’s RND() is implemented differently.   If the problem is that the RND() is repeating, here’s an idea for a workaround.  When you land on an existing object, instead of just computing an absolute position 1..8,1..8 again, one could compute an offset, say 1..5, 1..5.  Add that to the original point (unwrapping if need be), then try again.  Since 8 and 5 are mutually prime, you’d probably be able to avoid repetition.


I’m still working my way through the code and haven’t yet figured out all of it.  I’ll definitely review your notes and appreciate any further advice.




CODE DETAILS: Note that the line numbers in the discussions below are the line numbers in the original listing, which is muc more readable

DOCKING
-------
As far as the bug on line 1060, I thought it was a bug at first too, but later realized that it was working as intended.  What happens is that immediately after that line, on line 1070, it calls GOSUB 1100, which sets O=1, marking it as docked.   

Here’s why that line is there. Imagine if 1060 didn’t have the IF, so it just read like this:

  1060 PRINT "Sulu: 'Captain, we are docked at Starbase.'"

What would happen is that Sulu would announce that you’re at the starbase every turn that you’re there.  But we only want Sulu to announce when we first arrive.  When we first arrive, O will still be 0, so he’ll announce it.

If the code is working right, your line 875 is not needed.  O will get set to 0 on line 1030.


BUT… there *is* a bug in the docking code as written.  The problem is the extra test lines that I’ve marked with ***

                         
  880 I = X - (X > 1)              : Row to start searching on
  890 REM DO
  900 IF I > X + (X < 8) GOTO 1010 : Row to stop searching on  
  910 J = Y - (Y > 1)              : Column to start searching on
  920 REM DO
  930 IF J > Y + (Y < 8) GOTO 970  : Column to stop searching on  
  940 IF @(8 * I + J + 62) = 2 GOTO 970
  950 J = J + 1
  960 GOTO 920
  970 REM LOOP

  980 IF @(8 * I + J + 62) = 2 GOTO 1010   : ***
  990 I = I + 1
  1000 GOTO 890
  1010 REM LOOP

  1020 IF @(8 * I + J + 62) = 2 GOTO 1050  : ***
  1030 O = 0
  1040 RETURN                       : No starbase found, mark not docked and return
  1050 REM END IF

The problem occurs when the loop falls through.  Suppose you want to look in columns 2 through 4.  But there’s a starbase in column 5.  The DO loop has a property similar to a C for loop, where, after the loop exits, the index variable will be one larger than the final index value.  So In my example, J will be 5 when you fail the test on like 930.   Then, when you get to 980, you find the starbase in column 5, and you are marked as docked even though there’s a gap between the E and the B.

I’m not sure why line 980 and 1020 are in there, but they just don’t belong as far as I can tell.  I rewrote this entire block as follows.   It’s clear how it works, and how O gets set to zero if you’re not docked.

My rewrite of 880-1050
      880 FOR I = X - (X > 1) TO X + (X < 8) 
      910   FOR J = Y - (Y > 1) TO Y + (Y < 8)
      940     IF @(8 * I + J + 62) = 2 GOTO 1060
      950   NEXT J
      1000 NEXT I

      1030 O = 0         : No starbase found, mark not docked and return
      1040 RETURN             
      1050 REM END IF



FASCINATING (TL;DR section)
---------------------------
I was truly fascinated by what was going on in the path computation subroutine on line 5950 and then the math on 4570.  I finally realized that it was a mash-up of 2 or 3 concepts.

First, the stuff on line 6020 is implementing a linearized version of sine and cosine.  That is, it is computing the triangle-wave approximation to sine and cosine.


Next, it is implementing a form of floating point, which it seems like you reverse-engineered as well.  Really it’s fixed point.  All the values are scaled by 45.  In essence all the calcs are being done in units of 1/45 of a sector.

Once they have the X and y quadrature values, they can compute sine and cosine as just X/R and Y/R, as long as everything is normalized properly, which they cleverly take care of by pinning the larger of X and Y at 1.0 (or 45 45ths) and letting the other value and R scale to accommodate.  I don’t yet deeply understand that scaling but, but it’s super clever.


Then when you get back to line 4580,  P G and W all get scaled to units of 45’ths, (including 22/45 like adding +0.5) then converted back to sectors.

Then in line 4900 and following, the 45ths first get converted to 9ths by dividing by 5, and the 72 gets introduced because a full quadrant is 72/9 sectors wide.

  4900 P = U * 72 + P / 5 + W / 5 * S / R - 9  : New global sector number (row)
  4910 U = P / 72                              : New quadrant (row)
  4920 G = V * 72 + G / 5 + W / 5 * T / R - 9
  4930 V = G / 72

The 9ths are then carried until line 5000 when they are finally rounded to integers again.



LITTLE ENHANCEMENTS
-------------------
I decided that the game was a bit too easy when you can just fly into a quadrant and blast all the Klingons before they get a chance to defend themselves.  For that change, I set A=0 on line 5030.  May also want to set it to zero on line 5100.  I can’t recall right now if I changed it elsewhere.

I wanted it to print out Red Alert when I entered a sector with Klingons, and to make the terminal beep.  So I changed line 6490 to say:

  648 J=1 : PR. : PR. "RED ALERT!!",$7

And I wanted it to beep at me anytime I got hit by a Klingon, so I added the $7 to line 3440 as well.


I also found the 30-turn limit to be nearly impossible to win when there are large numbers of Klingons.  So I set D=40 at the top of the file.


MY CODE
-------
As you can see, the source code itself is very difficult to read and has no comments.  I don’t think it’s going to be of much use to others right now, except to simply copy if you have an Altaids machine.

So in addition to my code, I’ve posted a file containing my annotations, sort of like your handwritten markup.  I may go back at some point and add REM lines.  Once the code is stable, they won’t be much of a penalty for me – the Palo Altaids Basic provides a way to write out and read back “TBI” files which are the machine’s internal version of the program once loaded, a fair bit faster than loading the source.


At some point, what would be really useful (maybe somebody has already written this?) is a preprocessor that inserts the abbreviations and removes spaces and REM lines.  Then one could write a readable program that could still be compact for loading.
