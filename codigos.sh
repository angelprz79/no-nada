#!/bin/bash

g++ cerebro.cpp -o programa || exit 1
printf '%s\n' '-------------------------------------------------------'
printf '%s\n' '      Bienvenidos al programa de BigData Sets'
printf '%s\n\n' '-------------------------------------------------------'
read -r -p "Ingrese cantidad de alumnos: " cantidad </dev/tty || {
    printf '%s\n' "No se pudo leer la cantidad desde la terminal." >&2
    exit 1
}
if ! [[ "$cantidad" =~ ^[1-9][0-9]*$ ]]; then
    printf '%s\n' "La cantidad debe ser un entero positivo." >&2
    exit 1
fi

coproc PROGRAMA { stdbuf -o0 ./programa; }
programa_entrada=${PROGRAMA[1]}
programa_salida=${PROGRAMA[0]}
printf '%s\n' "$cantidad" >&"$programa_entrada"

esperar_respuesta() {
    local linea
    while IFS= read -r linea <&"$programa_salida"; do
        if [[ "$linea" == "__FIN_ACCION__" ]]; then
            return 0
        fi
        printf '%s\n' "$linea"
    done
    printf '%s\n' "El programa terminó antes de completar la acción." >&2
    return 1
}

while true; do
    printf '\n%s\n' '---------------------- MENÚ ----------------------'
    printf '%s\n' '1.- Ingresar alumnos con número de lista'
    printf '%s\n' '2.- Ingresar alumnos sin número de lista'
    printf '%s\n' '3.- Ver alumnos por nombre'
    printf '%s\n' '4.- Ver alumnos por número de lista'
    printf '%s\n\n' '5.- Salir'

    read -r -p "Elija una opción: " opcion </dev/tty || break

    case "$opcion" in
        1|2|3|4|5) ;;
        *)
            printf '%s\n' "Opción inválida. Intente de nuevo." >&2
            continue
            ;;
    esac

    printf '%s\n' "$opcion" >&"$programa_entrada"
    case "$opcion" in
        1)
            for ((i = 0; i < cantidad; i++)); do
                read -r -p "Alumno $((i + 1)) [nombre] [numerolista]: " datos </dev/tty || exit 1
                printf '%s\n' "$datos" >&"$programa_entrada"
            done
            ;;
        2)
            for ((i = 0; i < cantidad; i++)); do
                read -r -p "Nombre del alumno $((i + 1)): " nombre </dev/tty || exit 1
                printf '%s\n' "$nombre" >&"$programa_entrada"
            done
            ;;
    esac

    esperar_respuesta || break
    [[ "$opcion" == 5 ]] && break
done

exec {programa_entrada}>&-
wait "$PROGRAMA_PID"