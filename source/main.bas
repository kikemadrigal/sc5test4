
10 rem Program:  Bosque
20 rem autor:    MSX Murcia
30 OPEN"grp:"AS#1:print #1,"Espere..."
1 'Nuestra pantalla tendrá el texto blanco, fondo verde y borde negro'
40 cls:color 1,3,1
1 'Inicilizamos el juego'
50 defint a-z: DEFUSR1=&H41:DEFUSR2=&H44
1 'Cuando se pulse el disparo ir a la subrutina de la línea 1530'
60 'ON STRIG GOSUB 1530
1 'Cuando haya colisión de sprites ir a la subrutina de la linea 1750'
70 'sprite on:ON SPRITE GOSUB 2000

1 'Pantalla de Bienvenida y records'


1 'Pantalla final'


1 'Inicializamos el mapa'
80 gosub 8000
1 'Cargamos todos los mapas o levels de un mundo en el array'
90 gosub 8100
1 'Mostramos el mapa'
100 gosub 8500
1 'inicilizamos el personaje'
120 gosub 5000
1 'inicilizamos los enemingos con el manager'
130 gosub 6000
1 'Creamos el 1 enemigo, la ev y la el es para que se mueva hacia arriba o hacia abajo'
140 gosub 6100:ex(1)=8*12:ey(1)=6*20:ev(1)=8:es(1)=4
150 gosub 6100:ex(2)=8*18:ey(2)=8*6:ev(2)=8:es(2)=4
160 gosub 6100:ex(3)=8*14:ey(3)=8*8:ev(3)=8:es(3)=6
170 'gosub 6100:ex(4)=8*30:ey(4)=8*10:el(4)=8:es(3)=6
1 'Mostramos la informacion'
180 gosub 3000


1 ' <<<<<< Main loop >>>>>'
    1 'Actualizamos el sistema de input'
    400 gosub 1260
    1 'Actualizamos el sistema de colisiones'
    430 gosub 1760
    1 'Actualizamos sistema del render
    440 gosub 1400
    1 'Actualizamos el sistema de fisicas'
    450 gosub 1900
500 goto 400 
1 ' <<<<<< Final del Main loop >>>>>'



1260 '' <<<< INPUT SYSTEM >>>>
    1265 '_TURBO ON (x,y,xp,yp,ph,pw,pp,mc,ms)
    1270 ST=STICK(0) OR STICK(1) OR STICK(2)
    1280 'TG=STRIG(0) OR STRIG(1) OR STRIG(2)
    1 'xp= posicion x previa player, yp=posición y previaplayer'
    1 'Conservamos la posición previa para las colisiones'
    1300 xp=x:yp=y
    1 'pv=player velocidad, pp=plano player, pc= layer columna y pf=player fila'
    1'1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
    1320 IF ST=7 THEN x=x-pv:pp=3
    1330 IF ST=3 THEN x=x+pv:pp=2
    1340 IF ST=1 THEN y=y-pv:pp=0
    1350 IF ST=5 THEN y=y+pv:pp=1
    1 'Colisones con los extremos de la pantalla'
    1370 if x<=0 then mc=1:ms=ms+1:x=xp
    1380 if y<=0 then mc=1:ms=ms+1:y=yp
    1385 if y+ph>192 then mc=1:ms=ms+1:y=yp
    1390 if x+pw>252 then mc=1:ms=ms+1x=xp
    1391 '_TURBO OFF
1395 RETURN


1400 '' <<< RENDER SYSTEM >>>>
    1 'Pintamos de nuevo el player con la posición, el color y el plano(dibujitos de izquierda, derecha..)'
    1420 PUT SPRITE 0,(x,y),,pp
    1 'dibujamos los enemigos, sin el for ser ve más claro'
    1430 for i=1 to en-1
        1 'Esto es para animar los muñegotes'
        1440 es(i)=es(i)+1 
        1450 if es(i)>5 and i=1 then es(i)=4
        1460 if es(i)>5 and i=2 then es(i)=4
        1470 if es(i)>7 and i=3 then es(i)=6
        1480 if es(i)>7 and i=4 then es(i)=6
        1 'Nuestros enemigos son el sprite 5 en adelante'
        1490 PUT SPRITE 4+i,(ex(i),ey(i)),,es(i)
    1495 next i
    1 'Si el mapa seleccionado es mayor que 5 cambiamos el mundo llamando a la subrrutina 8100'
    1 'Si el mapa cambia volvemos a pintar un nuevo mapa con 8500
    1 'y ponemos al player en su posición del mapa seleccionado'
    1500 if ms >5 then mw=mw+1:ms=0:mc=1:gosub 8100
    1510 if mc then gosub 8500
1520 return




1' '' <<< COLLISION SYSTEM >>>>
    1 'Colisiones del player con el mapa'
    1 'Para detectar la colisión vemos el valor que hay en la tabla de nombres de la VRAM
    1 'En la posición x e y de nuestro player con la formula: '
    1 'Si hay una colision le dejamos la posicion que guardamos antes de cambiarla por pulsar una tecla'
    1760 hl=base(5)+(y/8)*32+(x/8):a=vpeek(hl)
    1 'Si el valor es igual a 244 (nuestro ladrillo) ponemos los valores que tenía antes de pulsar el cursor'
    1770 if a=224 then x=xp: y=yp
    1 'Si el valor es un 204 nuestro punto de fuga lo mandamos a otro sitio '
    1780 if a=204 then x=8*16: y=8*18:beep
    1 ' Si el valor el 215 (el tiled de la meta) cambiamos de mapa'
    1790 if a=215 then mc=1:ms=ms+1
    1 'Colisiones del player con sprites de los enemigos (mirar línea 70 y 2000)'
    1800 if pc=1 then pc=0:sprite on

    1 'Colisiones de ememigos con el mapa'
    1810 for i=0 to en-1
        1820 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1 'ev es la vlocidad eje x y el es la velocidad eje y'
        1 'Si es una pared le invertimos la velocidad del eje x y del eje y'
        1 'y le volvemos a poner las coordenadas antiuas '
        1 'ev=velocidad x y el velocidad eje y '
        1 'ep coordenada previa x , ei=coordenada previa y'
        1830 if a=224 then ev(i)=-ev(i):el(i)=-el(i):ex(i)=ep(i):ey(i)=ei(i)
        1 'Conservamos los datos de las posiciones antes de cambiarlos'
        1840 ep(i)=ex(i):ei(i)=ey(i)   
    1860 next i
1870 return

1 '<<< PHYSICS SYSTEM >>>>
    1 'Actualizamos la posicion del enemigo'
    1900 for i=0 to en-1
        1910 ex(i)=ex(i)+ev(i):ey(i)=ey(i)+el(i)
    1920 next i
1930 return

1 'Cuando 2 sprites colisionan...'
1 'Si no tiene vidas salimos del juego'
    2000 'if pe=0 then gosub 5000
    1 'La magia del basic nos obliga a desactivar las colisiones entre sprites'
    1 'Le quitamos una vida o energía
    1 'gosub 3300 actualizamos la informacion del juego'
    1 'Por ultimo volvemos a poner nuestro personaje en la posición del mapa inicial'
    1 'Actualizamos la variable player colision que nos ayuda a activar la colisiones (linea 1800)'
    2010 sprite off:pe=pe-1:gosub 3000:beep:gosub 5100:pc=1
2090 return

1 'informacion del juego que aparece en l aparte superior'
    3000 preset (0,0): print #1,"Level "mw"-"ms" free: "fre(0)
    3010 'locate 0,23: print "MEMSIZ: "peek(&hF672)", free:"fre(0)
    3020 'locate 0,21: print "x "x" y"y
    1 'hex$(VARPTR(m(0,0,0)))'
3030 return


1 '---------------------------------------------------------'
1 '------------------------PLAYER---------------------------'
1 '---------------------------------------------------------'

1 ' Inicializando el personaje'
    1 ' x=pisicon x previa, utilizada en el sistema de input'
    1 ' y= posicion y previa, utilizada en el sistema de input'
    1 ' pe=player energy o vida
    1 'Player colision, se utiliza para habilitar el sprite on cuando hay una colision'
    5000 x=8:y=16:xp=0:yp=0:pw=8:ph=8:pv=8:pe=10:pc=0
5020 return


1 '---------------------------------------------------------'
1 '------------------------ENEMIES MANAGAER------------------'
1 '---------------------------------------------------------'

1 'Definiendo la extructura de los enemigos'
1 'em=numero maximo de enemigos'
1 'et=turno de enemigo'
1 'en=numero de enemigo'
1 'Componente de posicion'
    1 'ex=coordenada x, ey=coordenada y', ep=coordenada previa x, ei=coordenada previa y
1 'Componente de fisica'
    1 'ev=velocidad enemigo eje x, el=velocidad eje y'
1 'Componente de render'
    1 'ew=ancho enemigo, eh= alto enemigo, es=enemigo sprite'
1 'Componente RPG'
    1 'ee=enemigo energia '

1 'Init'
1 'con en=1 (enemigo número)le decimos que queremos trabajar con el enemigo 1
1 'Pero vamos a rellenar la entidad 0 para que despues podamos copiar sus valores en la 1 y las demás que creemos'
1 'Después de estudiar la subrrutina 6000 y 6100 mira la línea 140'
    6000 en=1
    6020 ex(0)=0:ey(0)=0:ep(0)=0:ei(0)=0
    6030 ev(0)=0:el(0)=0
    6040 ew(0)=8:eh(0)=8:es(0)=5
    6050 ee(0)=100
6060 return

1 ' Crear enemigo'
    1 'Como el espacio en la memoria lo creamos en el loader, ahora rellenamos, 
    1 'el dibujado lo hacemos en el render '
    1 'Aqui le asignamos el sprite que será el definido en el lodaer '
    1 'En lugar de ponerles valores le copiamos los valores de la entidad creada en el init'
    1 'la siguiente vez que llamemos a crear enemigo se creará en la siguiente posición del array'
    6100 ex(en)=ex(0):ey(en)=ey(0):ep(en)=ep(0):ei(0)=ei(0)
    6120 ev(en)=ev(0):el(en)=el(0)
    6130 ew(en)=ew(0):eh(en)=eh(0):es(en)=es(0)
    6140 ee(en)=ee(0)
    1 'Al sumarle un enemigo cuando volvamos a llamar a esta subrrutina
    1 'Creará el enemigo en la siguiente posición, pero antes fíjate en las dimensiones 
    1 'Que le reservaste en el loader.bas'
    6150 en=en+1
6160 return


1 '---------------------------------------------------------'
1 '------------------------MAPA---------------------------'
1 '---------------------------------------------------------'


1 ' inicializar_mapa
    1 '## ms=mapa seleccioando, lo hiremos cambiando    
    1 'mm= maximo de mapas, como hemos creado 2 levels ponemos mm=mapa maximo 2
    1 'mc= mapa cambia, lo utilizaremos para cambiar los copys y así cambiar la pantalla
    8000 mw=0:ms=0:mm=3:mc=0:tn=0
    1 '22 serán la filas y 32 las columnas menos uno, porque así son los arrays'
    1 'He intenado crear este array en el loader pero me dice out of memory'
    8010 dim m(23,31,mm-1)
8020 return

1 'Guardar_mapa_en_array

    1 'Cada mapa ocupa 862 bytes'
    1 'md=mapa dirección, la dirección c001 se la he puesto yo en el archivo binario cuando lo creé'
    1 'El archivo tan solo contiene los datos de la definición de los mapas'
    8100 md=&hc001:locate 0,0
    8105 'print #1,"Cargando mundo..."
    8110 if mw=0 then bload"word0.bin",r
    8120 if mw=1 then bload"word1.bin",r
    8130 for i=0 to mm-1
        1 'ahora leemos las filas o la posición x
        8140 for f=0 to 12
        1 'ahora leemos las columnas c o la posicion y
            8150 for c=0 to 15
                8160 m(f,c,i)=peek(md):md=md+1
            8170 next c
        8180 next f
    8190 next i
8200 return




1 'Render map, pintar mapa
    1 'la pantalla en screen 1 con width son:
    1 '256px de ancho que /16 tiles=13 tiles de 16px 
    1 '212px de alto que /16 tiles=16 tiles de 16px
    8500 cls:mc=0
    1 'usr1(0) llama a deshabilitar la pantalla'
    8510 a=usr1(0)
    8520 locate 0,0
    8525 'print #1,"Cargando nivel"
    8530 _TURBO ON (tn,m(),ms,mm)
    8540 for i=0 to mm-1 
        8550 for f=0 to 12
        1 'ahora leemos las columnas c
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
    1 'usr2(0) llama a habilitar la pantalla'
    8840 a=usr2(0)
    1 'Mostramos la informacion del juego'
    8850 gosub 3000
8860 return

