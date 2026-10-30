@echo off
chcp 65001 >nul
cd /d "%~dp0"

where g++ >nul 2>&1
if errorlevel 1 (
    echo No se encontro g++ en el PATH.
    echo Instala MinGW-w64 o MSYS2 y agrega su carpeta bin al PATH.
    pause
    exit /b 1
)

g++ cerebro.cpp -o programa.exe
if errorlevel 1 (
    echo Error al compilar cerebro.cpp
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText('%~f0'); Invoke-Expression $s.Substring($s.LastIndexOf('#PS_START'))"
set "codigo=%errorlevel%"
pause
exit /b %codigo%

#PS_START
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$utf8 = New-Object Text.UTF8Encoding($false)

Write-Host '-------------------------------------------------------'
Write-Host '      Bienvenidos al programa de BigData Sets'
Write-Host '-------------------------------------------------------'
Write-Host ''

$cantidad = Read-Host 'Ingrese cantidad de alumnos'
if ($cantidad -notmatch '^[1-9][0-9]*$') {
    [Console]::Error.WriteLine('La cantidad debe ser un entero positivo.')
    exit 1
}
$cantidad = [int]$cantidad

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = Join-Path (Get-Location) 'programa.exe'
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.StandardOutputEncoding = $utf8
$proc = [System.Diagnostics.Process]::Start($psi)

$entrada = New-Object IO.StreamWriter($proc.StandardInput.BaseStream, $utf8)
$entrada.NewLine = "`n"
$entrada.AutoFlush = $true
$salida = $proc.StandardOutput

function Esperar-Respuesta {
    while ($null -ne ($linea = $salida.ReadLine())) {
        if ($linea -eq '__FIN_ACCION__') { return $true }
        Write-Host $linea
    }
    [Console]::Error.WriteLine('El programa terminó antes de completar la acción.')
    return $false
}

$entrada.WriteLine($cantidad)

while ($true) {
    Write-Host ''
    Write-Host '---------------------- MENÚ ----------------------'
    Write-Host '1.- Ingresar alumnos con número de lista'
    Write-Host '2.- Ingresar alumnos sin número de lista'
    Write-Host '3.- Ver alumnos por nombre'
    Write-Host '4.- Ver alumnos por número de lista'
    Write-Host '5.- Salir'
    Write-Host ''

    $opcion = Read-Host 'Elija una opción'
    if ($opcion -notin '1','2','3','4','5') {
        [Console]::Error.WriteLine('Opción inválida. Intente de nuevo.')
        continue
    }

    $entrada.WriteLine($opcion)

    if ($opcion -eq '1') {
        for ($i = 1; $i -le $cantidad; $i++) {
            $datos = Read-Host "Alumno $i [nombre] [numerolista]"
            $entrada.WriteLine($datos)
        }
    }
    elseif ($opcion -eq '2') {
        for ($i = 1; $i -le $cantidad; $i++) {
            $nombre = Read-Host "Nombre del alumno $i"
            $entrada.WriteLine($nombre)
        }
    }

    if (-not (Esperar-Respuesta)) { break }
    if ($opcion -eq '5') { break }
}

$entrada.Close()
$proc.WaitForExit()