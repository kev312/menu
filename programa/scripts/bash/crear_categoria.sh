#!/bin/bash

TIENDA="/tiendas/ElVestidor"

while true; do
    echo -n "Indica el nombre de la nueva categoría (s para salir): "
    read nombre

    # Salir
    if [ "$nombre" = "s" ]; then
        exit 0
    fi

    # Validación del nombre: no vacío, solo letras y números
    if [[ -z "$nombre" ]] || [[ "$nombre" =~ [^A-Za-z0-9] ]]; then
        echo "Error: el nombre de la categoría no puede estar vacío ni contener caracteres no válidos."
        continue
    fi

    # Comprobar existencia
    if [ -d "$TIENDA/$nombre" ]; then
        echo "Error: la categoría ya existe."
        continue
    fi

    # Crear directorio y darle permisos
    mkdir -p "$TIENDA/$nombre"
    chmod 777 "$TIENDA/$nombre"

    echo "Categoría '$nombre' creada correctamente."
    read -n 1 -s -r -p "Pulsa una tecla para continuar..."
    break
done
