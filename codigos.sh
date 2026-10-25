#!/bin/bash

g++ cerebro.cpp -o programa || exit 1
echo "--------Bienvenidos al programa de BigData Sets--------"
read -r -p "Ingrese cantidad de alumnos: " cantidad
if ! [[ "$cantidad" =~ ^[1-9][0-9]*$ ]]; then
    echo "La cantidad debe ser un entero positivo."
    exit 1
fi
{
    # Primer dato que recibe el C++
    printf '%s\n' "$cantidad"
    while true; do
        # El menú se muestra en la terminal, sin enviarlo al C++.
        echo "1.-Ingresar alumnos con número de lista" >&2
        echo "2.-Ingresar alumnos sin número de lista" >&2
        echo "3.-Ver alumnos por nombre" >&2
        echo "4.-Ver alumnos por número de lista" >&2
        echo "5.-Salir" >&2

        read -r -p "Elija una opción: " opcion || break

        case "$opcion" in
            1|2|3|4|5) ;;
            *)
                echo "Opción inválida." >&2
                continue
                ;;
        esac

        # Lo recibe: cin >> opcion;
        printf '%s\n' "$opcion"

        case "$opcion" in
            1)
                for ((i = 0; i < cantidad; i++)); do
                    read -r -p "Alumno $((i + 1)) [nombre] [numerolista]: " datos || exit
                    printf '%s\n' "$datos"
                done
                ;;
            2)
                for ((i = 0; i < cantidad; i++)); do
                    read -r -p "Nombre del alumno $((i + 1)): " nombre || exit
                    printf '%s\n' "$nombre"
                done
                ;;
            5)
                break
                ;;
        esac
    done

} | ./programa