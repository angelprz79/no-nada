#!/bin/bash
 
platillos=("Tacos al pastor" "Enchiladas verdes" "Quesadilla" "Agua de horchata" "Refresco" "Pastel de chocolate")
precios=(45 60 35 20 25 50)
 
pedido_nombres=()
pedido_cantidades=()
pedido_precios=()
 
mostrar_menu() {
    echo "----------------------------------------"
    echo " MENÚ DEL RESTAURANTE"
    echo "----------------------------------------"
    for i in "${!platillos[@]}"; do
        printf "%d.- %-22s \$%s\n" "$((i + 1))" "${platillos[$i]}" "${precios[$i]}"
    done
    echo "----------------------------------------"
}
 
agregar_platillo() {
    mostrar_menu
    read -r -p "Elige el número del platillo: " opcion
 
    if ! [[ "$opcion" =~ ^[0-9]+$ ]] || (( opcion < 1 || opcion > ${#platillos[@]} )); then
        echo "Opción inválida."
        return
    fi
 
    read -r -p "¿Cuántas unidades? " cantidad
    if ! [[ "$cantidad" =~ ^[1-9][0-9]*$ ]]; then
        echo "La cantidad debe ser un entero positivo."
        return
    fi
 
    indice=$((opcion - 1))
    pedido_nombres+=("${platillos[$indice]}")
    pedido_cantidades+=("$cantidad")
    pedido_precios+=("${precios[$indice]}")
 
    echo "Agregado: $cantidad x ${platillos[$indice]}"
}
 
ver_pedido() {
    if [ ${#pedido_nombres[@]} -eq 0 ]; then
        echo "Aún no has agregado nada a tu pedido."
        return
    fi
 
    echo "----------------------------------------"
    echo " TU PEDIDO"
    echo "----------------------------------------"
    total=0
    for i in "${!pedido_nombres[@]}"; do
        subtotal=$(( pedido_cantidades[i] * pedido_precios[i] ))
        printf "%s x%s  ->  \$%s\n" "${pedido_nombres[$i]}" "${pedido_cantidades[$i]}" "$subtotal"
        total=$((total + subtotal))
    done
    echo "----------------------------------------"
    echo "TOTAL: \$$total"
    echo "----------------------------------------"
}
 
eliminar_platillo() {
    if [ ${#pedido_nombres[@]} -eq 0 ]; then
        echo "No hay nada que eliminar."
        return
    fi
 
    ver_pedido
    read -r -p "¿Qué número de línea quieres eliminar? " linea
 
    if ! [[ "$linea" =~ ^[0-9]+$ ]] || (( linea < 1 || linea > ${#pedido_nombres[@]} )); then
        echo "Opción inválida."
        return
    fi
 
    indice=$((linea - 1))
    echo "Eliminado: ${pedido_nombres[$indice]}"
    unset 'pedido_nombres[indice]'
    unset 'pedido_cantidades[indice]'
    unset 'pedido_precios[indice]'
    pedido_nombres=("${pedido_nombres[@]}")
    pedido_cantidades=("${pedido_cantidades[@]}")
    pedido_precios=("${pedido_precios[@]}")
}
 
echo "========================================"
echo " BIENVENIDO AL RESTAURANTE"
echo "========================================"
 
while true; do
    echo ""
    echo "1.- Ver menú"
    echo "2.- Agregar platillo al pedido"
    echo "3.- Ver pedido actual"
    echo "4.- Eliminar un platillo del pedido"
    echo "5.- Salir y pagar"
    read -r -p "Elige una opción: " opcion
 
    case "$opcion" in
        1) mostrar_menu ;;
        2) agregar_platillo ;;
        3) ver_pedido ;;
        4) eliminar_platillo ;;
        5)
            echo ""
            echo "Gracias por tu pedido. Aquí está tu cuenta:"
            ver_pedido
            echo "¡Que disfrutes tu comida!"
            break
            ;;
        *)
            echo "Opción inválida, intenta de nuevo."
            ;;
    esac
done

