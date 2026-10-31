@echo off
chcp 65001 >nul
title BigData Sets
set "ARCHIVO_BAT=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$b=[IO.File]::ReadAllBytes($env:ARCHIVO_BAT); try{$s=[Text.UTF8Encoding]::new($false,$true).GetString($b)}catch{$s=[Text.Encoding]::GetEncoding(1252).GetString($b)}; Invoke-Expression ($s.Substring($s.LastIndexOf('#PS_START')))"
set "CODIGO=%errorlevel%"
echo.
pause
exit /b %CODIGO%

#PS_START
# ===========================================================================
#  BigData Sets - programa unico (reemplaza a cerebro.cpp + el script bash)
#  No necesita compilador: todo se ejecuta con el PowerShell que trae Windows.
# ===========================================================================
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# ---------------------------- utilidades -----------------------------------
function Leer-Texto([string]$mensaje) {
    $t = Read-Host $mensaje
    if ($null -eq $t) { exit 1 }      # entrada cerrada (Ctrl+Z / Ctrl+C)
    return $t.Trim()
}

function Mostrar-Error([string]$mensaje) {
    Write-Host $mensaje -ForegroundColor Red
}

# Opcion 2: pide un nombre (no puede quedar vacio)
function Leer-Nombre([int]$i) {
    while ($true) {
        $t = Leer-Texto "Nombre del alumno $i"
        if ($t -ne '') { return $t }
        Mostrar-Error 'El nombre no puede estar vacío.'
    }
}

# Opcion 1: pide "nombre numerolista" (el numero es lo ultimo de la linea)
function Leer-AlumnoConNL([int]$i) {
    while ($true) {
        $linea = Leer-Texto "Alumno $i [nombre] [numerolista]"
        if ($linea -match '^(.+?)\s+([0-9]{1,15})$' -and [long]$Matches[2] -ge 1) {
            return [pscustomobject]@{ Nombre = $Matches[1].Trim(); NL = [long]$Matches[2] }
        }
        Mostrar-Error 'Formato inválido. Escribe el nombre, un espacio y el número de lista (entero positivo). Ejemplo: Ana 5'
    }
}

# Comparadores identicos a los de C++ (comparacion por bytes: mayusculas antes
# que minusculas), no los de Windows, que ignoran mayusculas/minusculas.
# Equivale a sort() sobre vector<pair<string,ll>>: primero nombre, luego NL.
$cmpPorNombre = [Comparison[object]]{
    param($x, $y)
    $c = [string]::CompareOrdinal($x.Nombre, $y.Nombre)
    if ($c -ne 0) { return $c }
    return $x.NL.CompareTo($y.NL)
}
# Equivale a sort() sobre vector<pair<ll,string>>: primero NL, luego nombre.
$cmpPorNL = [Comparison[object]]{
    param($x, $y)
    $c = $x.NL.CompareTo($y.NL)
    if ($c -ne 0) { return $c }
    return [string]::CompareOrdinal($x.Nombre, $y.Nombre)
}

# ------------------------------ bienvenida ---------------------------------
Write-Host '-------------------------------------------------------'
Write-Host '      Bienvenidos al programa de BigData Sets'
Write-Host '-------------------------------------------------------'
Write-Host ''

$n = 0
while ($true) {
    $t = Leer-Texto 'Ingrese cantidad de alumnos'
    if ($t -match '^[1-9][0-9]{0,5}$') { $n = [int]$t; break }
    Mostrar-Error 'La cantidad debe ser un entero positivo.'
}

# ------------------- estructuras (las mismas que en cerebro.cpp) ------------
# alumnos / alumnos3 en C++: alumnos CON numero de lista
$alumnosConNL = [System.Collections.Generic.List[object]]::new()
# ALUMNOS en C++: alumnos SIN numero de lista, el indice i-1 es el NL asignado i
$sinNLPorNL = [System.Collections.Generic.List[string]]::new()
# ALUMNOS2 en C++: alumnos SIN numero de lista ordenados por nombre
# (si un nombre se repite, queda una sola entrada con el ultimo NL, igual que map)
$sinNLPorNombre = [System.Collections.Generic.SortedDictionary[string,long]]::new([StringComparer]::Ordinal)

# --------------------------------- menu ------------------------------------
while ($true) {
    Write-Host ''
    Write-Host '---------------------- MENÚ ----------------------'
    Write-Host '1.- Ingresar alumnos con número de lista'
    Write-Host '2.- Ingresar alumnos sin número de lista'
    Write-Host '3.- Ver alumnos por nombre'
    Write-Host '4.- Ver alumnos por número de lista'
    Write-Host '5.- Salir'
    Write-Host ''

    $opcion = Leer-Texto 'Elija una opción'
    if ($opcion -notmatch '^[1-5]$') {
        Mostrar-Error 'Opción inválida. Intente de nuevo.'
        continue
    }

    if ($opcion -eq '1') {
        # Ingresar alumnos con numero de lista (vacia solo la lista con NL)
        $alumnosConNL.Clear()
        for ($i = 1; $i -le $n; $i++) {
            $alumnosConNL.Add((Leer-AlumnoConNL $i))
        }
        Write-Host ''
    }
    elseif ($opcion -eq '2') {
        # Ingresar alumnos sin numero de lista: se ordenan por nombre y el NL
        # se asigna segun la posicion (1..n). Vacia todo lo anterior.
        $alumnosConNL.Clear()
        $sinNLPorNL.Clear()
        $sinNLPorNombre.Clear()
        $nombres = [System.Collections.Generic.List[string]]::new()
        for ($i = 1; $i -le $n; $i++) {
            $nombres.Add((Leer-Nombre $i))
        }
        $nombres.Sort([StringComparer]::Ordinal)
        $k = 1
        foreach ($nombre in $nombres) {
            $sinNLPorNL.Add($nombre)
            $sinNLPorNombre[$nombre] = $k
            $k++
        }
        Write-Host ''
    }
    elseif ($opcion -eq '3') {
        # Ver alumnos por nombre
        if ($alumnosConNL.Count -gt 0) {
            $alumnosConNL.Sort($cmpPorNombre)
            Write-Host ''
            foreach ($al in $alumnosConNL) {
                Write-Host "Alumno: $($al.Nombre) N.L: $($al.NL)"
            }
        }
        elseif ($sinNLPorNombre.Count -gt 0) {
            Write-Host ''
            foreach ($par in $sinNLPorNombre.GetEnumerator()) {
                Write-Host "Alumno: $($par.Key) N:L: $($par.Value)"
            }
        }
        else {
            Write-Host ''
            Write-Host 'No has ingresado ningun alumno'
            Write-Host ''
            Write-Host ''
        }
    }
    elseif ($opcion -eq '4') {
        # Ver alumnos por numero de lista
        if ($alumnosConNL.Count -gt 0) {
            $alumnosConNL.Sort($cmpPorNL)
            Write-Host ''
            foreach ($al in $alumnosConNL) {
                Write-Host "NL: $($al.NL) Alumno: $($al.Nombre)"
            }
        }
        elseif ($sinNLPorNL.Count -gt 0) {
            Write-Host ''
            for ($i = 1; $i -le $sinNLPorNL.Count; $i++) {
                Write-Host "NL: $i Alumno: $($sinNLPorNL[$i - 1])"
            }
        }
        else {
            Write-Host ''
            Write-Host 'No has ingresado ningun alumno'
            Write-Host ''
            Write-Host ''
        }
    }
    else {
        # Salir
        Write-Host ''
        break
    }
}