@echo off
chcp 65001 >nul & rem activa UTF-8 para que se vean los acentos
title Listado de alumnos
set "ARCHIVO_BAT=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$b=[IO.File]::ReadAllBytes($env:ARCHIVO_BAT); try{$s=[Text.UTF8Encoding]::new($false,$true).GetString($b)}catch{$s=[Text.Encoding]::GetEncoding(1252).GetString($b)}; Invoke-Expression ($s.Substring($s.LastIndexOf('#PS_START')))" & rem ejecuta el programa que esta mas abajo
set "CODIGO=%errorlevel%"
echo.
pause & rem espera una tecla para que no se cierre la ventana
exit /b %CODIGO%

#PS_START
[Console]::OutputEncoding = [Text.Encoding]::UTF8

function Leer-Texto([string]$mensaje) {
    $t = Read-Host $mensaje
    if ($null -eq $t) { exit 1 }   # si se cierra la entrada, termina el programa y pues ya se cierra nomas 
    return $t.Trim()               # quita espacios al inicio y al final
}

function Mostrar-Error([string]$mensaje) {
    Write-Host $mensaje -ForegroundColor Red   # muestra el error en rojo
}

function Leer-Nombre([int]$i) {
    while ($true) {
        $t = Leer-Texto "Nombre del alumno $i"
        if ($t -ne '') { return $t }   # solo acepta nombres que no esten vacios
        Mostrar-Error 'El nombre no puede estar vacío.'
    }
}

function Leer-AlumnoConNL([int]$i) {
    while ($true) {
        $linea = Leer-Texto "Alumno $i [nombre] [numerolista]"
        if ($linea -match '^(.+?)\s+([0-9]{1,15})$' -and [long]$Matches[2] -ge 1) {   # separa nombre y NL, el NL debe ser entero positivo
            return [pscustomobject]@{ Nombre = $Matches[1].Trim(); NL = [long]$Matches[2] }   # devuelve el alumno como par nombre y NL
        }
        Mostrar-Error 'Formato inválido. Escribe el nombre, un espacio y el número de lista (entero positivo). Ejemplo: Ana 5'
    }
}

$cmpPorNombre = [Comparison[object]]{   # ordena por nombre y luego por NL (como pair<string,ll>)
    param($x, $y)
    $c = [string]::CompareOrdinal($x.Nombre, $y.Nombre)   # compara por bytes: mayusculas antes que minusculas
    if ($c -ne 0) { return $c }
    return $x.NL.CompareTo($y.NL)
}

$cmpPorNL = [Comparison[object]]{   # ordena por NL y luego por nombre (como pair<ll,string>)
    param($x, $y)
    $c = $x.NL.CompareTo($y.NL)
    if ($c -ne 0) { return $c }
    return [string]::CompareOrdinal($x.Nombre, $y.Nombre)
}

Write-Host '-------------------------------------------------------'
Write-Host '      Bienvenidos al programa de BigData Sets'
Write-Host '-------------------------------------------------------'
Write-Host ''

$n = 0   # numero de alumnos
while ($true) {
    $t = Leer-Texto 'Ingrese cantidad de alumnos'
    if ($t -match '^[1-9][0-9]{0,5}$') { $n = [int]$t; break }   # acepta solo enteros positivos
    Mostrar-Error 'La cantidad debe ser un entero positivo.'
}

$alumnosConNL = [System.Collections.Generic.List[object]]::new()   # alumnos con NL (alumnos y alumnos3)
$sinNLPorNL = [System.Collections.Generic.List[string]]::new()   # alumnos sin NL asignado ordenados por NL (ALUMNOS)
$sinNLPorNombre = [System.Collections.Generic.SortedDictionary[string,long]]::new([StringComparer]::Ordinal)   # alumnos sin NL asignado ordenados por nombre (ALUMNOS2)

while ($true) {   # repite el menu hasta que se elija la opcion 5
    Write-Host ''
    Write-Host '---------------------- MENÚ ----------------------'
    Write-Host '1.- Ingresar alumnos con número de lista'
    Write-Host '2.- Ingresar alumnos sin número de lista'
    Write-Host '3.- Ver alumnos por nombre'
    Write-Host '4.- Ver alumnos por número de lista'
    Write-Host '5.- Salir'
    Write-Host ''

    $opcion = Leer-Texto 'Elija una opción'
    if ($opcion -notmatch '^[1-5]$') {   # solo acepta opciones del 1 al 5
        Mostrar-Error 'Opción inválida. Intente de nuevo.'
        continue   # vuelve a mostrar el menu
    }

    if ($opcion -eq '1') {   # opcion 1: ingresar alumnos con NL
        $alumnosConNL.Clear()   # vacia la lista para que no haya problema de sobreescritura
        for ($i = 1; $i -le $n; $i++) {
            $alumnosConNL.Add((Leer-AlumnoConNL $i))   # guarda cada alumno con su NL
        }
        Write-Host ''
    }
    elseif ($opcion -eq '2') {   # opcion 2: ingresar alumnos sin NL
        $alumnosConNL.Clear()   # vacia todo para evitar problemas de sobreescritura
        $sinNLPorNL.Clear()
        $sinNLPorNombre.Clear()
        $nombres = [System.Collections.Generic.List[string]]::new()   # alumnos sin NL (soporte para el diccionario)
        for ($i = 1; $i -le $n; $i++) {
            $nombres.Add((Leer-Nombre $i))
        }
        $nombres.Sort([StringComparer]::Ordinal)   # ordena los nombres alfabeticamente
        $k = 1
        foreach ($nombre in $nombres) {
            $sinNLPorNL.Add($nombre)   # el NL es la posicion en la lista ordenada
            $sinNLPorNombre[$nombre] = $k   # guarda nombre y su NL
            $k++
        }
        Write-Host ''
    }
    elseif ($opcion -eq '3') {   # opcion 3: ver alumnos por nombre
        if ($alumnosConNL.Count -gt 0) {
            $alumnosConNL.Sort($cmpPorNombre)   # ordena por nombre
            Write-Host ''
            foreach ($al in $alumnosConNL) {
                Write-Host "Alumno: $($al.Nombre) N.L: $($al.NL)"   # imprime alumnos con NL asignado
            }
        }
        elseif ($sinNLPorNombre.Count -gt 0) {
            Write-Host ''
            foreach ($par in $sinNLPorNombre.GetEnumerator()) {
                Write-Host "Alumno: $($par.Key) N:L: $($par.Value)"   # imprime alumnos sin NL asignado
            }
        }
        else {
            Write-Host ''
            Write-Host 'No has ingresado ningun alumno'   # todavia no hay alumnos
            Write-Host ''
            Write-Host ''
        }
    }
    elseif ($opcion -eq '4') {   # opcion 4: ver alumnos por NL
        if ($alumnosConNL.Count -gt 0) {
            $alumnosConNL.Sort($cmpPorNL)   # ordena por NL
            Write-Host ''
            foreach ($al in $alumnosConNL) {
                Write-Host "NL: $($al.NL) Alumno: $($al.Nombre)"   # imprime alumnos con NL asignado
            }
        }
        elseif ($sinNLPorNL.Count -gt 0) {
            Write-Host ''
            for ($i = 1; $i -le $sinNLPorNL.Count; $i++) {
                Write-Host "NL: $i Alumno: $($sinNLPorNL[$i - 1])"   # imprime alumnos sin NL asignado en orden de NL
            }
        }
        else {
            Write-Host ''
            Write-Host 'No has ingresado ningun alumno'   # todavia no hay alumnos
            Write-Host ''
            Write-Host ''
        }
    }
    else {   # opcion 5: salir
        Write-Host ''
        break
    }
}