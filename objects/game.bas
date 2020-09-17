10 rem Program:  Bosque
20 rem autor:    MSX Murcia
30 OPEN"grp:"AS#1:print #1,"Espere..."
40 cls:color 1,3,1
50 defint a-z: DEFUSR1=&H41:DEFUSR2=&H44
60 'ON STRIG GOSUB 1530
70 'sprite on:ON SPRITE GOSUB 2000
80 gosub 8000
90 gosub 8100
100 gosub 8500
120 gosub 5000
130 gosub 6000
140 gosub 6100:ex(1)=8*12:ey(1)=6*20:ev(1)=8:es(1)=4
150 gosub 6100:ex(2)=8*18:ey(2)=8*6:ev(2)=8:es(2)=4
160 gosub 6100:ex(3)=8*14:ey(3)=8*8:ev(3)=8:es(3)=6
170 'gosub 6100:ex(4)=8*30:ey(4)=8*10:el(4)=8:es(3)=6
180 gosub 3000
    400 gosub 1260
    430 gosub 1760
    440 gosub 1400
    450 gosub 1900
500 goto 400 
1260 '' <<<< INPUT SYSTEM >>>>
    1265 '_TURBO ON (x,y,xp,yp,ph,pw,pp,mc,ms)
    1270 ST=STICK(0) OR STICK(1) OR STICK(2)
    1280 'TG=STRIG(0) OR STRIG(1) OR STRIG(2)
    1300 xp=x:yp=y
    1320 IF ST=7 THEN x=x-pv:pp=3
    1330 IF ST=3 THEN x=x+pv:pp=2
    1340 IF ST=1 THEN y=y-pv:pp=0
    1350 IF ST=5 THEN y=y+pv:pp=1
    1370 if x<=0 then mc=1:ms=ms+1:x=xp
    1380 if y<=0 then mc=1:ms=ms+1:y=yp
    1385 if y+ph>192 then mc=1:ms=ms+1:y=yp
    1390 if x+pw>252 then mc=1:ms=ms+1x=xp
1395 RETURN
1400 '' <<< RENDER SYSTEM >>>>
    1420 PUT SPRITE 0,(x,y),,pp
    1430 for i=1 to en-1
        1440 es(i)=es(i)+1 
        1450 if es(i)>5 and i=1 then es(i)=4
        1460 if es(i)>5 and i=2 then es(i)=4
        1470 if es(i)>7 and i=3 then es(i)=6
        1480 if es(i)>7 and i=4 then es(i)=6
        1490 PUT SPRITE 4+i,(ex(i),ey(i)),,es(i)
    1495 next i
    1500 if ms >5 then mw=mw+1:ms=0:mc=1:gosub 8100
    1510 if mc then gosub 8500
1520 return
    1760 hl=base(5)+(y/8)*32+(x/8):a=vpeek(hl)
    1770 if a=224 then x=xp: y=yp
    1780 if a=204 then x=8*16: y=8*18:beep
    1790 if a=215 then mc=1:ms=ms+1
    1800 if pc=1 then pc=0:sprite on
    1810 for i=0 to en-1
        1820 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1830 if a=224 then ev(i)=-ev(i):el(i)=-el(i):ex(i)=ep(i):ey(i)=ei(i)
        1840 ep(i)=ex(i):ei(i)=ey(i)   
    1860 next i
1870 return
    1900 for i=0 to en-1
        1910 ex(i)=ex(i)+ev(i):ey(i)=ey(i)+el(i)
    1920 next i
1930 return
    2000 'if pe=0 then gosub 5000
    2010 sprite off:pe=pe-1:gosub 3000:beep:gosub 5100:pc=1
2090 return
    3000 preset (0,0): print #1,"Level "mw"-"ms" free: "fre(0)
    3010 'locate 0,23: print "MEMSIZ: "peek(&hF672)", free:"fre(0)
    3020 'locate 0,21: print "x "x" y"y
3030 return
    5000 x=8:y=16:xp=0:yp=0:pw=8:ph=8:pv=8:pe=10:pc=0
5020 return
    6000 en=1
    6020 ex(0)=0:ey(0)=0:ep(0)=0:ei(0)=0
    6030 ev(0)=0:el(0)=0
    6040 ew(0)=8:eh(0)=8:es(0)=5
    6050 ee(0)=100
6060 return
    6100 ex(en)=ex(0):ey(en)=ey(0):ep(en)=ep(0):ei(0)=ei(0)
    6120 ev(en)=ev(0):el(en)=el(0)
    6130 ew(en)=ew(0):eh(en)=eh(0):es(en)=es(0)
    6140 ee(en)=ee(0)
    6150 en=en+1
6160 return
    8000 mw=0:ms=0:mm=3:mc=0:tn=0
    8010 dim m(23,31,mm-1)
8020 return
    8100 md=&hc001:locate 0,0
    8105 'print #1,"Cargando mundo..."
    8110 if mw=0 then bload"word0.bin",r
    8120 if mw=1 then bload"word1.bin",r
    8130 for i=0 to mm-1
        8140 for f=0 to 12
            8150 for c=0 to 15
                8160 m(f,c,i)=peek(md):md=md+1
            8170 next c
        8180 next f
    8190 next i
8200 return
    8500 cls:mc=0
    8510 a=usr1(0)
    8520 locate 0,0
    8525 'print #1,"Cargando nivel"
    8530 _TURBO ON (tn,m(),ms,mm)
    8540 for i=0 to mm-1 
        8550 for f=0 to 12
            8560 for c=0 to 15
                8570 'ms=0
                8580 tn= m(f,c,ms)
                8590 'print #1," "tn;
                8600 if tn >=0 and tn <=15 then copy (tn*16,0*16)-((tn*16)+16,(0*16)+16),1 to (c*16,f*16),0,tpset
                8610 if tn >15 and tn <=31 then copy ((tn-16)*16,1*16)-(((tn-16)*16)+16,(1*16)+16),1 to (c*16,f*16),0,tpset
                8620 if tn >31 and tn <=47 then copy ((tn-32)*16,2*16)-(((tn-32)*16)+16,(2*16)+16),1 to (c*16,f*16),0,tpset
                8630 if tn>47 and tn <=63 then copy ((tn-48)*16,3*16)-(((tn-48)*16)+16,(3*16)+16),1 to (c*16,f*16),0,tpset
                8640 if tn>63 and tn <=79 then copy ((tn-64)*16,4*16)-(((tn-64)*16)+16,(4*16)+16),1 to (c*16,f*16),0,tpset
                8650 if tn>79 and tn <=95 then copy ((tn-80)*16,5*16)-(((tn-80)*16)+16,(5*16)+16),1 to (c*16,f*16),0,tpset
                8660 if tn>95 and tn <=111 then copy ((tn-96)*16,6*16)-(((tn-96)*16)+16,(6*16)+16),1 to (c*16,f*16),0,tpset
                8670 if tn>111 and tn <=127 then copy ((tn-112)*16,7*16)-(((tn-112)*16)+16,(7*16)+16),1 to (c*16,f*16),0,tpset
                8680 if tn>127 and tn <=143 then copy ((tn-128)*16,8*16)-(((tn-128)*16)+16,(8*16)+16),1 to (c*16,f*16),0,tpset
                8690 if tn>143 and tn <=159 then copy ((tn-144)*16,9*16)-(((tn-144)*16)+16,(9*16)+16),1 to (c*16,f*16),0,tpset
                8700 if tn>159 and tn <=175 then copy ((tn-160)*16,10*16)-(((tn-160)*16)+16,(10*16)+16),1 to (c*16,f*16),0,tpset
                8710 if tn>175 and tn <=191 then copy ((tn-176)*16,11*16)-(((tn-176)*16)+16,(11*16)+16),1 to (c*16,f*16),0,tpset
                8720 if tn>191 and tn <=207 then copy ((tn-192)*16,12*16)-(((tn-192)*16)+16,(12*16)+16),1 to (c*16,f*16),0,tpset
               
            8800 next c
        8810 next f
    8820 next i
    8830 _TURBO off
    8840 a=usr2(0)
    8850 gosub 3000
8860 return
