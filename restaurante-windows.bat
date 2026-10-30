@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

set "NP=6"
set "nom1=Tacos al pastor"
set "nom2=Enchiladas verdes"
set "nom3=Quesadilla"
set "nom4=Agua de horchata"
set "nom5=Refresco"
set "nom6=Pastel de chocolate"
set "pre1=45"
set "pre2=60"
set "pre3=35"
set "pre4=20"
set "pre5=25"
set "pre6=50"
set "N=0"

echo ========================================
echo  BIENVENIDO AL RESTAURANTE
echo ========================================

:menu_principal
echo.
echo 1.- Ver menú
echo 2.- Agregar platillo al pedido
echo 3.- Ver pedido actual
echo 4.- Eliminar un platillo del pedido
echo 5.- Salir y pagar
set "op="
set /p "op=Elige una opción: "

if "!op!"=="1" call :mostrar_menu & goto menu_principal
if "!op!"=="2" call :agregar_platillo & goto menu_principal
if "!op!"=="3" call :ver_pedido & goto menu_principal
if "!op!"=="4" call :eliminar_platillo & goto menu_principal
if "!op!"=="5" goto salir
echo Opción inválida, intenta de nuevo.
goto menu_principal

:salir
echo.
echo Gracias por tu pedido. Aquí está tu cuenta:
call :ver_pedido
echo ¡Que disfrutes tu comida^^!
pause
exit /b 0

rem ---------------------------------------------------------
:mostrar_menu
echo ----------------------------------------
echo  MENÚ DEL RESTAURANTE
echo ----------------------------------------
for /l %%i in (1,1,%NP%) do (
    set "linea=!nom%%i!                      "
    set "linea=!linea:~0,22!"
    echo %%i.- !linea! $!pre%%i!
)
echo ----------------------------------------
exit /b

rem ---------------------------------------------------------
:validar_entero
rem Entrada: variable V. Devuelve 1 si no es un entero positivo (max. 6 digitos).
echo !V!| findstr /r "^[1-9][0-9]*$" >nul || exit /b 1
if not "!V:~6!"=="" exit /b 1
exit /b 0

rem ---------------------------------------------------------
:agregar_platillo
call :mostrar_menu
set "o="
set /p "o=Elige el número del platillo: "
set "V=!o!"
call :validar_entero || (
    echo Opción inválida.
    exit /b
)
if !o! GTR %NP% (
    echo Opción inválida.
    exit /b
)

set "c="
set /p "c=¿Cuántas unidades? "
set "V=!c!"
call :validar_entero || (
    echo La cantidad debe ser un entero positivo.
    exit /b
)

set /a N+=1
for %%k in (!o!) do (
    set "pn!N!=!nom%%k!"
    set "pp!N!=!pre%%k!"
    set "pc!N!=!c!"
    echo Agregado: !c! x !nom%%k!
)
exit /b

rem ---------------------------------------------------------
:ver_pedido
if !N!==0 (
    echo Aún no has agregado nada a tu pedido.
    exit /b
)
echo ----------------------------------------
echo  TU PEDIDO
echo ----------------------------------------
set /a total=0
for /l %%i in (1,1,!N!) do (
    set /a sub=!pc%%i! * !pp%%i!
    echo !pn%%i! x!pc%%i!  -^>  $!sub!
    set /a total+=sub
)
echo ----------------------------------------
echo TOTAL: $!total!
echo ----------------------------------------
exit /b

rem ---------------------------------------------------------
:eliminar_platillo
if !N!==0 (
    echo No hay nada que eliminar.
    exit /b
)
call :ver_pedido
set "l="
set /p "l=¿Qué número de línea quieres eliminar? "
set "V=!l!"
call :validar_entero || (
    echo Opción inválida.
    exit /b
)
if !l! GTR !N! (
    echo Opción inválida.
    exit /b
)

for %%k in (!l!) do echo Eliminado: !pn%%k!

set /a ult=N-1
for /l %%i in (!l!,1,!ult!) do (
    set /a s=%%i+1
    for %%j in (!s!) do (
        set "pn%%i=!pn%%j!"
        set "pp%%i=!pp%%j!"
        set "pc%%i=!pc%%j!"
    )
)
set "pn!N!="
set "pp!N!="
set "pc!N!="
set /a N-=1
exit /b