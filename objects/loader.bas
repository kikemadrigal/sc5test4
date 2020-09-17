1 ' ------------------------------------'
1 '     Loader - inicializador          '
1 ' ------------------------------------'

1 'Inicilizamos dispositivo: 003B, inicilizamos teclado: 003E'
10 defusr=&h003B:a=usr(0):defusr1=&h003E:a=usr1(0)
1 'El color de nuestro juego será texto blanco, fondo verde, bordes negros'
20 screen 5,2
25 color 15,1,1
1 'Mostramos la pantalla de carga'
30 bload "scload.bin",s
40 OPEN"grp:"AS#1:PRESET(0,10):PRINT#1,"Cargando..."
1 'Cargamos los sprites, la carag de los sprites debe de ser desde un bin'
1 'Pero para este ejemplo los cargaremos desde basic'
90 PRESET(0,10):PRINT#1,"Cargando sprites"
100 gosub 1000
1 'Ponemos el color de fondo transparente para copiar los gráficos en la page 0'
110 color 15,0,0
1 'Cargamos los gráficos'
130 PRESET(0,10):PRINT#1,"Cargando graficos              "
140 gosub 10000
1 'Inicializacion de las dimensiones de los arrays de nuestras entidades'
110 PRESET(0,10):PRINT#1,"Reservando espacio de arrays"
120 gosub 500
1 'Cargamos el xbasic'
150 PRESET(0,10):PRINT#1,"Cargando xbasic             "
160 bload"xbasic.bin",r
1 'Cargamos el main.bas'
170 PRESET(0,10):PRINT#1,"Escribiendo game.bas en RAM"
180 close #1
190 load "game.bas",r


    1 'Definiendo el espacio para los arrays con los valores de los enemigos'
    1 'creamos el espacio en la memoria para 3 enemigos'
    1 'Con em le decimos el espacio con en el enemigo actual que será actualizado o dibujado'
    1 'Para saber lo que es cada variable ir a la inicialización del enemigo'   
    1 'em=enemigos maximos'
    500 em=5
    1 ' Component position'
    510 DIM ex(em),ey(em),ep(em),ei(em)
    1 ' Compenent phisics'
    520 DIM ev(em),el(em)
    1 ' Component render'
    530 DIM ew(em),eh(em),es(em)
    1 ' Component RPG'
    540 DIM ee(em)

    1 'Definiendo el espacio de arrays con los valores de los mapas'
    1 'mm=mapas maximos'
    550 'mm=6:dim m(23,31,mm-1)
560 return



1 'Carga de sprites'
    1000 s=base(29)
    1 'aquí el 4 significa que vamos a cargar 4 definiciones de sprites de 32 bytes
    1010 for i=0 to (32*8)-1
        1020 read a
        1030 vpoke s+i,a
    1040 next i

    1050 for i=0 to (16*8)-1
        1060 read a
        1070 vpoke &h7400+i, a
    1080 next i
    1 'Player mirando arriba'
    1120 DATA &H00,&H03,&H03,&H03,&H03,&H03,&H0F,&H0B
    1130 DATA &H0B,&H03,&H03,&H0F,&H0F,&H0C,&H0C,&H1C
    1140 DATA &H00,&H00,&H80,&H00,&H80,&H00,&HC0,&H40
    1150 DATA &H40,&H00,&H00,&HC0,&HC0,&HC0,&HC0,&HE0
    1 'Player mirando abajo'
    1160 DATA &H00,&H03,&H03,&H03,&H03,&H03,&H07,&H07
    1170 DATA &H07,&H07,&H03,&H07,&H07,&H04,&H04,&H04
    1180 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H80,&H80
    1190 DATA &H80,&H80,&H00,&H80,&H80,&H80,&H80,&H80
    1 'Player mirando derecha'
    1200 DATA &H00,&H07,&H07,&H06,&H07,&H06,&H07,&H07
    1210 DATA &H07,&H07,&H06,&H07,&H07,&H07,&H07,&H07
    1220 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1230 DATA &H00,&H80,&H00,&H00,&H00,&H00,&H00,&H80
    1 'Player mirando izquierda'
    1240 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1250 DATA &H01,&H00,&H00,&H00,&H00,&H00,&H00,&H01
    1260 DATA &H00,&HE0,&HE0,&H60,&HE0,&H60,&HE0,&HE0
    1270 DATA &HE0,&HE0,&H60,&HE0,&HE0,&HE0,&HE0,&HE0
    1 'Coche mirando a la derecha
    1280 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1290 DATA &HFF,&H84,&H84,&HFF,&HFF,&HFF,&H38,&H38
    1300 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1310 DATA &H80,&HE0,&H3E,&HFE,&HFE,&HFC,&H1C,&H1C
    1 'Coche mirando a la izquierda'
    1320 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1330 DATA &H0F,&H1A,&HE2,&HFF,&HFF,&HFF,&H1C,&H1C
    1340 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1350 DATA &HFF,&H41,&H41,&HFF,&HFF,&HFE,&H0E,&H0E
    1 'Perro mirando a la dercha 1'
    1360 DATA &H00,&H00,&H81,&H81,&H81,&HE1,&HFF,&HFF
    1370 DATA &HFF,&HFF,&H9F,&HA3,&H22,&H06,&H04,&H00
    1380 DATA &H00,&H00,&H20,&H20,&HE0,&H20,&H20,&HE0
    1390 DATA &HE0,&HE0,&HC0,&HC0,&H40,&H60,&H20,&H20
    1 'Perro mirando a la dercha 2'
    1400 DATA &H00,&H00,&H04,&H04,&H07,&H04,&H04,&H07
    1410 DATA &H07,&H07,&H03,&H03,&H02,&H06,&H04,&H04
    1420 DATA &H00,&H00,&H81,&H81,&H81,&H87,&HFF,&HFF
    1430 DATA &HFF,&HFF,&HF9,&HC5,&H44,&H60,&H20,&H00



    1 'Definicion de los colores'
    1 'Color player mirando arriba'
    8000 DATA &H0F,&H08,&H08,&H0A,&H0A,&H0A,&H08,&H08
    8010 DATA &H08,&H08,&H08,&H0E,&H0E,&H0E,&H0E,&H05
    1 'Color player mirando abajo'
    8020 DATA &H0F,&H08,&H08,&H0A,&H0A,&H0A,&H08,&H08
    8030 DATA &H08,&H08,&H08,&H0E,&H0E,&H0E,&H0E,&H05
    1 'Color player mirando derecha'
    8040 DATA &H0F,&H08,&H08,&H0A,&H0A,&H0A,&H08,&H08
    8050 DATA &H08,&H08,&H08,&H0E,&H0E,&H0E,&H0E,&H05
    1 'Color player mirando izquierda'
    8060 DATA &H0F,&H08,&H08,&H0A,&H0A,&H0A,&H08,&H08
    8070 DATA &H08,&H08,&H08,&H0E,&H0E,&H0E,&H0E,&H05
    1 'Color coche mirando derecha'
    8080 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    8090 DATA &H0E,&H07,&H07,&H0E,&H0E,&H0E,&H04,&H04
    1 'Color coche mirando izquierda'
    8100 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    8110 DATA &H0E,&H07,&H07,&H0E,&H0E,&H0E,&H04,&H04
    1 'Color coche mirando derecha'
    8120 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    8130 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    1 'Color coche perro izquierda'
    8140 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    8150 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F


8500 return


1 'Cargando gráficos'
    1 'Despues de convertir nuestra imagen.png em http://msx.jannone.org/conv/
    1 'lo metemos en la page 1 (no la 0)'
    10000 bload"tileset.bin",s,&h8000
10010 return












