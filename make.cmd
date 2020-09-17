rem Varibles de configuración
set TARGET_CAS=juego.cas
set TARGET_WAV=juego.wav
set TARGET_DSK=juego.dsk
set TARGET_ROM=juego.rom

rem con esta línea le estamos diciendo que tiene que empezar por la función main
@echo off&cls&call:main %1&goto:EOF

:main
    echo MSX Murcia 2020
    rem Ckequeando parámetros
    if [%1]==[] (call :create_all)
    if [%1]==[dsk] (call :create_dsk)
    if [%1]==[rom] (call :create_rom)
    if [%1]==[cas] (call :create_cas)
    if [%1]==[clean] (call :clean_objets)
    rem si el argumento no está vacío, ni es dsk, ni es cas, etc
    if [%1] NEQ [] (
        if [%1] NEQ [rom] (
            if [%1] NEQ [dsk] (
                if [%1] NEQ [cas] ( 
                    if [%1] NEQ [clean] (call :help) 
                )
            )
        )
    )    
goto:eof



:create_all
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_dsk
    call :crear_rom
    call :crear_cas
    call :crear_wav
    call :abrir_emulador_con_dsk
goto:eof

:create_dsk
    echo Escogiste crear dsk
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_dsk
    call :abrir_emulador_con_dsk
goto:eof


:create_rom
    echo Escogiste crear rom
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_dsk
    call :crear_rom
    call :abrir_emulador_con_rom
goto:eof



:create_cas
    echo Escogiste crear cas
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_cas
    call :crear_wav
    call :abrir_emulador_con_wav
goto:eof

:clean_objets
    echo escogiste borrar objetos
    del /F /Q objects\*.*
goto:eof

:help
     echo No reconozco la sintaxis, pon:
     echo .
     echo make [dsk] [rom] [cas] [clean]
goto:eof

















rem ----------------------------------------------------------------------------
rem Esta función prepará los archivos fuente pata incluirlos en un dsk, cas 

:preparar_archivos_fuente
    rem del /F /Q objects\loader.bas
    rem creamos la carpeta obects si no existe, si existe borramos su contenido
    If not exist .\objects (md .\objects) else (call :clean_objets)

    rem Creando .bin de los levels o mundos
    start /wait tools\sjasm\sjasm.exe source\word0.asm
    rem start /wait tools\sjasm\sjasm.exe source\word1.asm
    move /Y word0.bin ./bin
    rem move /Y word1.bin ./bin
 
    rem Copiando todos los archivos.bas de la carpeta source
    rem los pegamos en objects y mostramos un mensajito
    for /R source %%a in (*.bas) do (
        copy "%%a" objects & echo %%a)

    rem Le quitamos los comentarios a game.bas
    java -jar tools/deletecomments/deletecomments1.2.jar source/main.bas objects/game.bas  
    rem escribe type /? y find /? paa más ayuda
    rem type objects\gametemp.bas | find /V  "1 '"  > objects\game.bas
    rem del /F /Q objects\gametemp.bas
    echo Comentarios eliminados y creado game.bas
    
    rem Borramos el main.bas y nos quedamos solo con el de sin comentarios
    del /F /Q objects\main.bas
goto:eof









:convertir_imagenes
 rem ir a: http://msx.jannone.org/conv/
goto:eof





rem -----------------------------------------------------------------------------
rem Creará un nuevo archivo .dsk con los archivos .bin y .bas especificados
:crear_dsk
    rem Crear nuevo dsk
    rem como diskmanager no puede crear dsk vacíos desde el cmd copiamos y pegamos uno vacío
    if exist %TARGET_DSK% del /f /Q %TARGET_DSK%
    copy tools\Disk-Manager\main.dsk .\%TARGET_DSK%
    rem añadimos todos los .bas de la carpeta objects al disco
    rem por favor mirar for /?
    for /R objects/ %%a in (*.bas) do (
        start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   

    rem añadimos todos los arhivos binarios de la carpeta bin al disco
    rem recuerda que un sc2, sc5, sc8 es también un archivo binario, renombralo
    rem por favor mirar for /?
    for /R bin/ %%a in (*.bin) do (
        start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   
goto:eof



:crear_rom
    rem esto generará una rom de 32kb
    start /wait tools\dsk2rom\dsk2rom.exe -c 2 -f %TARGET_DSK% %TARGET_ROM% 
goto:eof



:crear_cas
    rem set TYPE=$1
    rem set TAPENAME=$2
    rem set PATHFILE=$3
    rem start /wait tools\mkcas\mkcas.py %TAPENAME% %TYPE% %PATHFILE%
    rem por favor, visita https://github.com/reidrac/mkcas
    if exist %TARGET_CAS% del /f /Q %TARGET_CAS%
    rem start /wait tools\mkcas\mkcas.py %TARGET_CAS% ascii objects\game.bas
    start /wait tools\mkcas\mkcas.py %TARGET_CAS% --add --addr 0x8000 --exec 0x8000  ascii objects\game.bas
    start /wait tools\mkcas\mkcas.py %TARGET_CAS% --add --addr 0x9000 --exec 0x9000  binary bin\sc5-01.bin
goto:eof

:crear_wav:
    start /wait tools\mcp\mcp.exe -e %TARGET_CAS% %TARGET_WAV%
goto:eof














rem ----------------------------------------------------------------
rem Abrir Emulador
rem BlueMSX: http://www.msxblue.com/manual/commandlineargs_c.htm
rem openMSX poner "tools\emulators\openmsx\openmsx.exe -h" en el cmd
rem FMSX: FMSX https://fms.komkon.org/fMSX/fMSX.html
rem para utilizar dir as disk tendrás que crear un directorio dsk/
:abrir_emulador_con_dir_as_disk
    copy main.dsk tools\emulators\BlueMSX
    start /wait tools/emulators/BlueMSX/blueMSX.exe -diska dsk/
    rem start /wait emulators/fMSX/fMSX.exe -diska dsk/
    rem start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska dsk/
goto:eof

:abrir_emulador_con_dsk
    rem copy %TARGET_DSK% tools\emulators\BlueMSX
    rem start /wait tools/emulators/BlueMSX/blueMSX.exe -diskA %TARGET_DSK%
    rem start /wait tools/emulators/fMSX/fMSX.exe -diska %TARGET_DSK%
    start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska %TARGET_DSK%
goto:eof
:abrir_emulador_con_cas
    rem copy %TARGET_CAS% tools\emulators\BlueMSX
    rem start /wait tools/emulators/BlueMSX/blueMSX.exe -cas %TARGET_CAS%
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_CAS%
    start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -cassetteplayer %TARGET_CAS%
goto:eof
:abrir_emulador_con_wav
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_WAV%
    start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -cassetteplayer %TARGET_WAV%
goto:eof
:abrir_emulador_con_rom   
    copy %TARGET_ROM% tools\emulators\BlueMSX
    start /wait tools/emulators/BlueMSX/blueMSX.exe -rom1 %TARGET_ROM%
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_ROM%
    rem start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -carta %TARGET_ROM%
goto:eof





:error
    echo "ha habido un error"
goto:eof