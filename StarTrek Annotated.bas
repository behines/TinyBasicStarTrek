10 REM DO
20 PRINT "Do you want a difficult game (y or n)?";
30 GOSUB 6770 
40 Y = 2999
50 IF A = 121 Y = 999   : REM Y affects number of Klingons
60 PRINT "Stardate 3200: your mission is",


70 REM DO
80 K = 0
90 B = 0
100 D = 30
110 I = 0

120 REM DO
130 IF I > 63 GOTO 220
140 J = (RND(99) + 1) < 5   : REM base in quadrant?
150 B = B + J               : REM total bases in game
160 M = RND(Y) + 1
170 M = (M < 209) + (M < 99) + (M < 49) + (M < 24) + (M < 9) + (M < 2)  : REM  0 to 6 Klingons
180 K = K + M  : REM Total Klingons
190 @(I) = -100 * M - 10 * J - RND(8) - 1   : REM Digits = Klingons, bases, stars.  The -1 is like a +1 but negative
200 I = I + 1
210 GOTO 120
220 REM LOOP

230 IF (B < 2) + (K < 4) GOTO 70    :REM Check that galaxy meets minimums
240 REM LOOP


250 PRINT "to destroy", K, "Klingons in 30 stardates."
260 PRINT "There are", B, "Starbases."


270 GOSUB 1100  : Init ship
280 C = 0       : Casualties
290 H = K       : Klingons total
300 GOSUB 6270  : Random sector and quadrant for Enterprise
310 GOSUB 6340  : Initialize sector contents
320 GOSUB 870   : Detect if docked
330 GOSUB 3230  : Klingon attack.  The game can start with an attack?
340 REM DO

350 REM DO - Input loop
360 PRINT "r=Report       s=SR. sensor   l=LR. sensor"
370 PRINT "g=Galaxy map   p=Phaser       t=Torpedo"
380 PRINT "w=Warp engine  ***please use one of these commands***"
390 PRINT "Captain?";
400 GOSUB 6770
410 IF A = 103 GOSUB 1370 : g
420 IF A = 108 GOSUB 1820 : l
430 IF A = 115 GOSUB 2100 : s
440 IF A = 112 GOSUB 2510 : p
450 IF A = 114 GOSUB 3870 : r
460 IF A = 119 GOSUB 4220 : w
470 IF A = 116 GOSUB 5130 : t
480 IF (A = 113) + (A = 27) A = -1  : q or Esc
490 IF A > 0 GOTO 350   : Flag indicating failed or bad command
500 REM LOOP

510 IF A = -1 GOTO 770     : Exit
520 GOSUB 870              : Check if we're docked
530 GOSUB 3230             : Klingon attack?
540 IF K GOTO 670          : Klingons remaining?
550 PRINT "Mission accomplished."
560 IF D < 3 PRINT "Boy, you barely made it."
570 IF D > 5 PRINT "Good work..."
580 IF D > 9 PRINT "Fantastic!"
590 IF D > 13 PRINT "Unbelievable!"
600 D = 30 - D
610 I = H * 100 / D * 10
620 PRINT H, "Klingons in", D, "stardates. (", I, ")"  : Raw score
630 J = 100 * (C = 0) - 5 * C
640 PRINT C, "casualties incurred. (", J, ")"
650 PRINT "Your score:", I + J
660 GOTO 770
670 REM END IF
680 IF D >= 0 GOTO 710
690 PRINT "It's too late, the federation has been conquered."
700 GOTO 770
710 REM END IF
720 IF E >= 0 GOTO 750   : Should go back to 340
730 PRINT "Enterprise destroyed"
740 IF H - K > 9 PRINT "But you were a good man"
750 REM END IF
760 GOTO 340             : If we're dead, why go back to the command input?  How about go to 600?

770 REM LOOP
780 Y = 987      : What is this?  Seems to have no effect.  Y gets reset on line 40
790 PRINT
800 PRINT "Another game (y or n)?";
810 GOSUB 6770
820 IF A = 121 GOTO 10
830 REM LOOP
840 PRINT "Good bye."
850 END



860 REM
870 REM SUBROUTINE 145 - Detect if we're docked.
                         
880 I = X - (X > 1)  : Row to start searching on

890 REM DO
900 IF I > X + (X < 8) GOTO 1010 : Row to stop searching on  
910 J = Y - (Y > 1)   : Column to start searching on
920 REM DO
930 IF J > Y + (Y < 8) GOTO 970  : Column to stop searching on  
940 IF @(8 * I + J + 62) = 2 GOTO 970
950 J = J + 1
960 GOTO 920
970 REM LOOP

980 IF @(8 * I + J + 62) = 2 GOTO 1010
990 I = I + 1
1000 GOTO 890
1010 REM LOOP

1020 IF @(8 * I + J + 62) = 2 GOTO 1050
1030 O = 0
1040 RETURN             : No starbase found, mark not docked and return
1050 REM END IF

My rewrite of 880-1050
      880 FOR I = X - (X > 1) TO X + (X < 8) 
      910   FOR J = Y - (Y > 1) TO Y + (Y < 8)
      940     IF @(8 * I + J + 62) = 2 GOTO 1060
      950   NEXT J
      1000 NEXT I

      1030 O = 0
      1040 RETURN             : No starbase found, mark not docked and return
      1050 REM END IF



                        : Starbase found.  If this is new, announce
1060 IF O = 0 PRINT "Sulu: 'Captain, we are docked at Starbase.'"
1070 GOSUB 1100         : Refuel and repair, mark as docked
1080 RETURN             : Note that 1070 and 1080 are not required - we could just fall through.



1090 REM
1100 REM SUBROUTINE 160 - Stock ship and mark as docked
1110 E = 4000  : REM energy  
1120 F = 10    : Torpedos
1130 O = 1     : Ship is Docked
1140 I = 64    : Damage Loop

1150 REM DO              : Repair everything
1160 IF  I > 70 GOTO 1200
1170 @(I) = 0
1180 I = I + 1
1190 GOTO 1150
1200 REM LOOP

1210 RETURN
1220 REM


1230 REM SUBROUTINE 165 - Choose random sector for object of type I
1240 REM DO
1250 S = RND(8) + 1
1260 T = RND(8) + 1
1270 A = 8 * S + T + 62  : Starts at 71
1280 IF @(A) GOTO 1240   : Make sure the sector isn't occupied
1290 REM LOOP
1300 @(A) = I
1310 RETURN


1320 REM
1330 REM SUBROUTINE 175 - Print Enterprise location
1340 PRINT "Enterprise in q-", U; ","; V, " s-", X; ","; Y

ADD?: If SR or LR are working, then Enterprise's current quadrant becomes known
1346 Z=8*U+V-9    : Get quadrant info  Z is a proxy for M
1347 IF (I > 0) * (I < 9) * (J > 0) * (J < 9) * (@(64)+@(66)=0) * (@(Z)<0)  @(Z) = -@(Z )


1350 RETURN


1360 REM
1370 REM SUBROUTINE map
1380 A = 1                    : Flag?
1390 GOSUB 1330               : Print Enterprise location
1400 J = 2
1410 GOSUB 3740               : Check for damage to computer display
1420 IF I RETURN
1430 PRINT "of galaxy map";
1440 I = 0                    : Row 0-7

1450 REM DO
1460 IF I > 7 GOTO 1600
1470 PRINT
1480 PRINT I + 1; ":",
1490 J = 0                    : Col 0-7

1500 REM DO
1510 IF J > 7 GOTO 1570
1520 M = @(8 * I + J)
1530 M = (M > 0) * M          : Negative values = not yet discovered
1540 PRINT M / 100; M / 10 - M / 100 * 10; M - M / 10 * 10,
1550 J = J + 1
1560 GOTO 1500

1570 REM LOOP
1580 I = I + 1
1590 GOTO 1450

1600 REM LOOP
1610 PRINT
1620 PRINT "  ",
1630 I = 0

1640 REM DO
1650 IF I > 7 GOTO 1690
1660 PRINT "...",
1670 I = I + 1
1680 GOTO 1640

1690 REM LOOP
1700 PRINT
1710 PRINT "   ",
1720 I = 1

1730 REM DO
1740 IF I > 8 GOTO 1780
1750 PRINT I, " ",
1760 I = I + 1
1770 GOTO 1730

1780 REM LOOP
1790 PRINT
1800 RETURN


1810 REM
1820 REM SUBROUTINE lr
1830 GOSUB 1330          : Print Enterprise location
1840 J = 3               : Check for damage to LRS
1850 GOSUB 3740
1860 IF I RETURN
1870 PRINT

1880 I = U - 1           : Loop from loc-1 to loc+1
1890 REM DO
1900 IF I > U + 1 GOTO 2060  : Bug: Need to filter for I<1 or I>8
  
   1905 IF (I<1)+(I>8) GOTO 2040

1910 J = V - 1           : Loop from loc-1 to loc+1
1920 REM DO
1930 IF J > V + 1 GOTO 2020  : Bug: Need to filter for I<1 or I>8

   1935 IF (J<1)+(J>8) GOTO 2000

1940 M = 8 * I + J - 9        
1950 A = 0
1960 IF (I > 0) * (I < 9) * (J > 0) * (J < 9) A = @(M)
1970 IF A < 0 A = -A
1980 @(M) = A
1990 PRINT A / 100; A / 10 - A / 100 * 10; A - A / 10 * 10,
2000 J = J + 1
2010 GOTO 1920

2020 REM LOOP
2030 PRINT
2040 I = I + 1
2050 GOTO 1890

2060 REM LOOP
2070 A = 1
2080 RETURN



2090 REM
2100 REM SUBROUTINE sr
2110 A = 1
2120 GOSUB 1330
2130 J = 1
2140 GOSUB 3740
2150 IF I RETURN
2160 M = 8 * U + V - 9
2170 IF @(M) < 0 @(M) = -@(M)   : Fills in this quadrant in galactic map
2180 PRINT
2190 I = 1
2200 REM DO
2210 IF I > 8 GOTO 2390
2220 PRINT I,
2230 J = 1
2240 REM DO
2250 IF J > 8 GOTO 2350
2260 M = @(8 * I + J + 62)
2270 IF M = 0 PRINT " .",
2280 IF M = 1 PRINT " K",
2290 IF M = 2 PRINT " B",
2300 IF M = 3 PRINT " *",
2310 IF M = 4 PRINT " E",
2320 IF (M < 0) + (M > 4) PRINT " ?",
2330 J = J + 1
2340 GOTO 2240
2350 REM LOOP
2360 PRINT
2370 I = I + 1
2380 GOTO 2200
2390 REM LOOP
2400 PRINT "  ",
2410 I = 1
2420 REM DO
2430 IF I > 8 GOTO 2470
2440 PRINT I; " ",
2450 I = I + 1
2460 GOTO 2420
2470 REM LOOP
2480 PRINT
2490 RETURN


2500 REM
2510 REM SUBROUTINE phaser
2520 J = 4
2530 A = 1
2540 GOSUB 3740
2550 IF I RETURN
2560 PRINT "energized. Units to fire";
2570 INPUT A
2580 IF A >= 1 GOTO 2610
2590 A = 1
2600 RETURN
2610 REM END IF
2620 IF A <= E GOTO 2660
2630 PRINT "Spock: 'We have only", E, "units.'"
2640 A = 1
2650 RETURN
2660 REM END IF
2670 E = E - A
2680 IF N >= 1 GOTO 2720
2690 PRINT "Phaser fired at empty space."
2700 A = 0
2710 RETURN
2720 REM END IF
2730 A = A / N
2740 M = 135
2750 REM DO
2760 IF M > 140 GOTO 2860
2770 IF @(M) GOTO 2800
2780 M = M + 1
2790 GOTO 2750
2800 REM END IF
2810 GOSUB 2900
2820 PRINT S, "units hit",
2830 GOSUB 3030
2840 M = M + 1
2850 GOTO 2750
2860 REM LOOP
2870 A = 0
2880 RETURN


2890 REM
2900 REM SUBROUTINE 295 - Klingon attack with energy A, damage returned in S
2910 IF A <= 1090 GOTO 2970
2920 PRINT "...overloaded..."
2930 J = 4       : What is damaged
2940 @(67) = 1   : Phaser damage, 1 stardate to repair
2950 A = 9       
2960 GOSUB 3740  : Report damage
2970 REM END IF
2980 I = @(M + 6) -  X  : Distance to Klingon
2990 J = @(M + 12) - Y
3000 S = A * 30 / (30 + I * I + J * J) + 1  : Damage from Klingon
3010 RETURN


3020 REM
3030 REM SUBROUTINE 305
3040 PRINT "Klingon at s-", @(M + 6); ","; @(M + 12),
3050 @(M) = @(M) - S
3060 IF @(M) <= 0 GOTO 3090
3070 PRINT "**damaged**"
3080 RETURN
3090 REM END IF
3100 @(M) = 0
3110 I = 8 * U + V - 9
3120 J = 0
3130 IF @(I) > 0 J = 1
3140 IF @(I) < 0 J = -1
3150 @(I) = @(I) - 100 * J
3160 K = K - 1
3170 I = 8 * @(M + 6) + @(M + 12) + 62
3180 @(I) = 0
3190 N = N - 1
3200 PRINT "***destroyed***"
3210 RETURN


3220 REM
3230 REM SUBROUTINE 325

3240 A = 1
          : No attack if no Klingons or if at starbase
3250 IF N = 0 RETURN   
3260 PRINT "Klingon attack"
3270 IF O = 0 GOTO 3300
3280 PRINT "Starbase protects Enterprise"
3290 RETURN
3300 REM END IF


3310 T = 0

3320 M = 135  : Loop, checking Klingon energy levels
3330 REM DO
3340 IF M > 140 GOTO 3470
3350 IF @(M) GOTO 3380    : Skip any Klingons with zero energy
3360 M = M + 1
3370 GOTO 3330
3380 REM END IF
3390 A = (@(M) + RND(@(M)) + 1) / 2   : Energy of Klingon attack - 50-100% of their shields
3400 GOSUB 2900                       : Compute damage from Klingon
3410 T = T + S                        : Accumulate damage
3420 I = @(M + 6)
3430 J = @(M + 12)
3440 PRINT S, "units hit from Klingon at s-", I; ","; J
3450 M = M + 1
3460 GOTO 3330
3470 REM LOOP

3480 E = E - T                        : Subtract damage from energy
3490 IF E > 0 GOTO 3520
3500 PRINT "*** bang ***"
3510 RETURN
3520 REM END IF
3530 PRINT E, "units of energy left."
3540 IF RND(E / 4) + 1 > T RETURN     : Threshold for damage to shields/casualties.  Probably should be before T is subtracted
3550 GOSUB 3590
3560 A = 1
3570 RETURN


3580 REM
3590 REM SUBROUTINE 360 - Compute damage to shields, or casualties if shields already damaged
3600 IF @(70) GOTO 3650           : Shields already damaged?
3610 @(70) = RND(T / 50 + 1) + 1  : No, compute turns to repair
3620 J = 7
3630 GOSUB 3740                   : Report damage
3640 RETURN

3650 REM END IF                   : No shields, compute further damange and casualties
3660 J = RND(6) + 1               : What gets damaged (not shields)
3670 @(J + 63) = RND(T / 99 + 1) + 1 + @(J + 63)   : Accrue damage 
3680 I = RND(8) + 2                : 2-9 casualties
3690 C = C + I
3700 PRINT "McCoy: 'Sickbay to bridge, we suffered", I, "casualties.'"
3710 GOSUB 3740                                    : Report damage
3720 RETURN


3730 REM
3740 REM SUBROUTINE 375 - Report damage to item
3750 I = @(J + 63)
3760 IF J = 1 PRINT "Short range sensor",
3770 IF J = 2 PRINT "Computer display",
3780 IF J = 3 PRINT "Long range sensor",
3790 IF J = 4 PRINT "Phaser",
3800 IF J = 5 PRINT "Warp engine",
3810 IF J = 6 PRINT "Photon torpedo tubes",
3820 IF J = 7 PRINT "Shield",
3830 IF I = 0 RETURN
3840 PRINT "damaged,", I, "stardates estimated for repair"
3850 RETURN



3860 REM
3870 REM SUBROUTINE report
3880 A = 1
3890 PRINT "Status report:"
3900 PRINT "Stardate", 3230 - D
3910 PRINT "Time left", D
3920 PRINT "Condition     ",
3930 IF O = 0 GOTO 3960
3940 PRINT "Docked"
3950 GOTO 4060
3960 REM ELSE
3970 IF N = 0 GOTO 4000
3980 PRINT "Red"
3990 GOTO 4060
4000 REM ELSE
4010 IF E >= 999 GOTO 4040
4020 PRINT "Yellow"
4030 GOTO 4060
4040 REM ELSE
4050 PRINT "Green"
4060 REM END IF
4070 PRINT "Position       q-", U; ","; V, " s-", X; ","; Y
4080 PRINT "Energy", E
4090 PRINT "Torpedoes", F
4100 PRINT "Klingons left", K
4110 PRINT "Starbases", B
4120 J = 1
4130 REM DO
4140 IF J > 7 GOTO 4180
4150 IF @(J + 63) GOSUB 3740
4160 J = J + 1
4170 GOTO 4130
4180 REM LOOP
4190 A = 1
4200 RETURN


4210 REM
4220 REM SUBROUTINE warp
4230 J = 5          : Check for damage
4240 A = 1
4250 GOSUB 3740
4260 IF I = 0 PRINT
4270 REM DO

4280 PRINT "Sector distance";
4290 INPUT W
4300 A = 1
4310 IF W < 1 RETURN
4320 IF I * (W > 2) = 0 GOTO 4350
4330 PRINT "Chekov: 'We can try 2 at most, sir.'"
4340 GOTO 4270
4350 REM END IF
4360 REM LOOP
4370 IF W <= 91 GOTO 4400
4380 W = 91
4390 PRINT "Spock: 'Are you sure, Captain?'"
4400 REM END IF
4410 IF E >= W * W / 2 GOTO 4440
4420 PRINT "Scotty: 'Sir, we do not have the energy.'"
4430 RETURN
4440 REM END IF
4450 GOSUB 5950   : Get course.  Returns R,S,T
4460 A = 1
4470 IF R = 0 RETURN
4480 D = D - 1
4490 E = E - W * W / 2
4500 @(8 * X + Y + 62) = 0   : Enterprise has left the sector
4510 M = 64
4520 REM DO
4530 IF M > 70 GOTO 4570
4540 @(M) = (@(M) - 1) * (@(M) > 0)  : Date just ticked, reduce damage count
4550 M = M + 1
4560 GOTO 4520
4570 REM LOOP

     : Scaling by 45 here is a form of fixed point arithmetic
     : Note that X and Y are the opposite of what their names imply.
4580 P = 45 * X + 22  : Scale current position by 45 and round, to match S,T
4590 G = 45 * Y + 22  : P=ROW,G=COL (P=-Y,G=X)
4600 W = 45 * W       : Scale thrust by 45

    : Motion within sector
4610 M = 1
4620 REM DO
4630 IF M > 8 GOTO 4810
4640 W = W - R
4650 IF W >= -22 GOTO 4700   : Travel range exhausted (<-0.5 left), stop here
4660 @(8 * X + Y + 62) = 4
4670 A = 0
4680 GOSUB 1330
4690 RETURN
4700 REM END IF
4710 P = P + S   : Add Y motion to Y
4720 G = G + T   : Add X motion to X
4730 I = P / 45  : Convert from fixed point back to integer.  I=row,J=Col
4740 J = G / 45
4750 IF (I < 1) + (I > 8) + (J < 1) + (J > 8) GOTO 4810  : Left the quadrant
4760 IF @(8 * I + J + 62) GOTO 4810    : Ran into object
4770 X = I
4780 Y = J
4790 M = M + 1
4800 GOTO 4620
4810 REM LOOP

  :Bug.  I don't think this line should be here.  4750 should go to 4900, 4760 to 4830
  :      This line, after successful loop exit, should just goto 4900
4820 IF @(8 * I + J + 62) = 0 GOTO 4890  : Didn't run into object, continue


4830 PRINT "**Emergency stop**"
4840 PRINT "Spock: 'To err is human.'"
4850 @(8 * X + Y + 62) = 4
4860 GOSUB 1330
4870 A = 0
4880 RETURN
4890 REM END IF

      : Do fixed point math with a scale factor of 9
      : There are 8 sectors per quadrant, so that's 72 when scaled
      : P,G,W are currently scaled by 45, so divide by 5 to get to scaled-by-9
      : S/R is Y motion per thrust, T/R is X motion per thrust
4900 P = U * 72 + P / 5 + W / 5 * S / R - 9  : New global sector number (row)
4910 U = P / 72                              : New quadrant (row)
4920 G = V * 72 + G / 5 + W / 5 * T / R - 9
4930 V = G / 72
4940 IF RND(9) + 1 >= 2 GOTO 4980
4950 PRINT "***Space storm***"
4960 T = 100
4970 GOSUB 3590
4980 REM END IF
4990 IF (U < 1) + (U > 8) + (V < 1) + (V > 8) GOTO 5050
5000 X = (P + 9 - 72 * U) / 9
5010 Y = (G + 9 - 72 * V) / 9
5020 GOSUB 6340
5030 A = 1    : Should be zero to allow attack
5040 RETURN
5050 REM END IF
5060 PRINT "**You wandered outside the galaxy**"
5070 PRINT "On board computer takes over, and saved your life"
5080 GOSUB 6270
5090 GOSUB 6340
5100 A = 1   : Should be zero to allow attack
5110 RETURN



5120 REM
5130 REM SUBROUTINE torpedo
5140 J = 6
5150 A = 1
5160 GOSUB 3740
5170 IF I RETURN
5180 IF F GOTO 5210
5190 PRINT "empty"
5200 RETURN
5210 REM END IF
5220 PRINT "loaded"
5230 GOSUB 5950
5240 IF R = 0 RETURN
5250 PRINT "Torpedo track",
5260 F = F - 1
5270 P = 45 * X + 22
5280 G = 45 * Y + 22
5290 M = 1
5300 REM DO
5310 IF M > 8 GOTO 5900
5320 P = P + S
5330 G = G + T
5340 I = P / 45
5350 J = G / 45
5360 IF (I < 1) + (I > 8) + (J < 1) + (J > 8) GOTO 5900
5370 L = 8 * I + J + 62
5380 W = 8 * U + V - 9
5390 R = 0
5400 IF @(W) > 0 R = 1
5410 IF @(W) < 0 R = -1
5420 PRINT I; ","; J, " ",
5430 A = 0
5440 IF @(L) <> 0 GOTO 5470
5450 M = M + 1
5460 GOTO 5300
5470 REM END IF
5480 IF @(L) <> 1 GOTO 5590
5490 S = RND(99) + 1 + 280
5500 M = 135
5510 REM DO
5520 IF M > 140 GOTO 5560
5530 IF (@(M + 6) = I) * (@(M + 12) = J) GOSUB 3030
5540 M = M + 1
5550 GOTO 5510
5560 REM LOOP
5570 A = 0
5580 RETURN
5590 REM END IF
5600 IF @(L) <> 2 GOTO 5680
5610 B = B - 1
5620 @(L) = 0
5630 @(W) = @(W) - 10 * R
5640 PRINT "Starbase destroyed"
5650 PRINT "Spock: 'I often find human behaviour fascinating.'"
5660 RETURN
5670 A = 0
5680 REM END IF
5690 IF @(L) <> 3 GOTO 5880
5700 PRINT "Hit a star"
5710 IF RND(9) + 1 >= 3 GOTO 5750
5720 PRINT "Torpedo absorbed"
5730 A = 0
5740 RETURN
5750 REM END IF
5760 @(L) = 0
5770 @(W) = @(W) - R
5780 IF RND(9) + 1 >= 6 GOTO 5820
5790 PRINT "Star destroyed"
5800 A = 0
5810 RETURN
5820 REM END IF
5830 T = 300
5840 PRINT "It novas ***radiation alarm***"
5850 GOSUB 3590
5860 A = 0
5870 RETURN
5880 REM END IF
5890 GOTO 5300
5900 REM LOOP
5910 PRINT "...missed"
5920 A = 0
5930 RETURN


5940 REM
5950 REM SUBRROUTINE 615
   : Computes linear approximation to sine and cosine, scaled by 45 => S/R and T/R  See spreadsheet
5960 PRINT "Course (0-360)";
5970 INPUT I
5980 IF (I <= 360) + (I >= 0) GOTO 6010  : Should be * per https://groups.io/g/ET-3400/message/2248
5990 R = 0
6000 RETURN
6010 REM END IF

6020 S = (I + 45) / 90   : A number between 0 and 4.  1,2,3,4 start at 45,135,225,315 deg
6030 I = I - S * 90      : Adjusts angle to be -45..44
6040 R = (45 + I * I) / 110 + 45   : R = 45..63.  45 when I close to 0, 63 when far
6050 IF S > 3 S = 0
6060 IF S <> 0 GOTO 6100
6070 S = -45
6080 T = I
6090 RETURN
6100 REM END IF
6110 IF S <> 1 GOTO 6150
6120 S = I
6130 T = 45
6140 RETURN
6150 REM END IF
6160 IF S <> 2 GOTO 6200
6170 S = 45
6180 T = -I
6190 RETURN
6200 REM END IF
6210 IF S <> 3 GOTO 6250
6220 S = -I
6230 T = -45
6240 RETURN
6250 REM END IF


6260 REM
6270 REM SUBROUTINE 40 : Init random sector and quadrant
6280 U = RND(8) + 1
6290 V = RND(8) + 1
6300 X = RND(8) + 1
6310 Y = RND(8) + 1
6320 RETURN

6330 REM
6340 REM SUBROUTINE 45 - Initialize sector contents
6350 I = 71

6360 REM DO  : Zero arrays
6370 IF I > 152 GOTO 6410
6380 @(I) = 0
6390 I = I + 1
6400 GOTO 6360
6410 REM LOOP

6420 @(8 * X + Y + 62) = 4   : Mark Enterprise, sector 1,1 = idx 71
6430 M = @(8 * U + V - 9)    : Get quadrant info
6440 IF M < 0 M = -M         
6450 N = M / 100             : Klingons
6460 I = 1                   : Klingons are object type 1
6470 IF N = 0 GOTO 6580      : Skip loop if no klingons
6480 J = 1

6490 REM DO : Loop over all klingons
6500 IF J > N GOTO 6570
6510 GOSUB 1230
6520 @(J + 134) = 300    : Klingon energy
6530 @(J + 140) = S      : S,T = Klingon sector for the up-to-6 klingons
6540 @(J + 146) = T
6550 J = J + 1
6560 GOTO 6490
6570 REM LOOP

6580 REM END IF  : (if no Klingons)
6590 GOSUB 1330         : Print out Enterprise location
6600 M = M - 100 * N    : Bases/Stars
6610 I = 2              : Bases are object type 2
6620 IF M / 10 GOSUB 1230  : Assign location if there is a base
6630 M = M - M / 10 * 10   : Number of stars
6640 I = 3                 : Star object type
6650 IF M = 0 GOTO 6730

6660 J = 1                 : Loop to assign random locations to stars
6670 REM DO
6680 IF J > M GOTO 6720
6690 GOSUB 1230
6700 J = J + 1
6710 GOTO 6670

6720 REM LOOP
6730 REM END IF
6740 A = 1                 : Flag indicating don't check?
6750 RETURN


6760 REM
6770 REM SUBROUTINE input
6780 REM DO
6790 INKEY A
6800 NAP 10
6810 IF A = -1 GOTO 6780
6820 REM LOOP
6830 PRINT
6840 RETURN