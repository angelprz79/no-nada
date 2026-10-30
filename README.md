# no-nada
esto es algo donde hay algo que consiste en que algo menciona algo siendo algo hecho para hacer algo o para dar algo a alguien

# Programas del repositorio

## Listado de alumnos

Este programa está compuesto por dos archivos que trabajan en conjunto:

- `Codigos.sh`
- `cerebro.cpp`

Ambos corresponden al proyecto **Listado de alumnos** y deben mantenerse juntos para su funcionamiento.

## Restaurante

El archivo `Restaurante.sh` corresponde al programa **Restaurante**. Su funcionamiento es independiente de **Listado de alumnos**.

## Ejecución

Los archivos que terminan en .bat es para poder ejecutar en windows sin necesidad de traducir los .sh o instalar una herramienta adicional para poder leerlos, la unica herramienta necesaria es un compilador g++ para poder ejecutar el cerebro.cpp y asi funcione bien junto al archivo codigos-windows.bat, sin este compilador no se podrá ejecutar de forma correcta el programa "Listado de alumnos"

## Instalación del compilador g++

> **Necesitas:** Windows 10 u 11 y conexión a internet.

### Paso 1: Abrir PowerShell

1. Pulsa la tecla **Windows** de tu teclado.
2. Escribe `powershell`.
3. Pulsa **Enter**. Se abrirá una ventana azul o negra con texto.

### Paso 2: Instalar el compilador

Copia esta línea, pégala en la ventana (clic derecho pega el texto) y pulsa **Enter**:

```
winget install BrechtSanders.WinLibs.POSIX.UCRT
```

- Si te pregunta si aceptas los términos, escribe `Y` y pulsa **Enter**.
- Espera a que termine. Puede tardar unos minutos.

### Paso 3: Cerrar y volver a abrir la terminal

**Cierra la ventana de PowerShell y abre una nueva** (como en el Paso 1). Este paso es importante: si usas la ventana anterior, Windows no reconocerá el compilador recién instalado.

### Paso 4: Comprobar que quedó instalado

En la ventana nueva, escribe esto y pulsa **Enter**:

```
g++ --version
```

Si aparece un texto que empieza con `g++.exe` y un número de versión, **todo está listo**.

### Paso 5: Ejecutar el programa

1. Descarga o clona este repositorio.
2. Asegúrate de que `cerebro.cpp` y `ejecutar.bat` estén **en la misma carpeta**.
3. Haz **doble clic** en `ejecutar.bat`.

El programa se compila solo y se abre listo para usar.

---

## Solución de problemas

**"winget no se reconoce como un comando"**
Abre la tienda de Microsoft Store, busca **"Instalador de aplicación"** (App Installer), instálalo o actualízalo y repite el Paso 2.

**"g++ no se reconoce como un comando" después de instalar**
1. Comprueba que cerraste PowerShell y abriste una ventana **nueva** (Paso 3).
2. Si sigue igual, **reinicia la computadora** y vuelve a probar el Paso 4.
3. Si aún no funciona, usa la instalación alternativa de abajo.

**El programa dice "No se encontro g++ en el PATH"**
Es el mismo problema de arriba: el compilador no está instalado o la terminal no lo reconoce. Repite los pasos 3 y 4.

---

## Instalación alternativa (si winget no funciona)

1. Entra a **https://www.msys2.org** y descarga el instalador.
2. Instálalo dejando todo por defecto (carpeta `C:\msys64`) y deja marcada la casilla **"Run MSYS2 now"** al final.
3. En la ventana que se abre, escribe este comando y pulsa **Enter**:
   ```
   pacman -S mingw-w64-ucrt-x86_64-gcc
   ```
   Cuando pregunte `Proceed with installation? [Y/n]`, escribe `Y` y pulsa **Enter**.
4. Agrega el compilador al PATH de Windows:
   1. Pulsa la tecla **Windows** y escribe `variables de entorno`.
   2. Elige **"Editar las variables de entorno de esta cuenta"**.
   3. Selecciona **Path** en la lista de arriba y pulsa **Editar...**
   4. Pulsa **Nuevo**, pega `C:\msys64\ucrt64\bin` y pulsa **Aceptar** en todas las ventanas.
5. Abre una terminal **nueva** y verifica con `g++ --version`.

## Dudas y sugerencias

Para cualquier duda o sugerencia, puedes comunicarte al **+52 55 3646 3180**.
