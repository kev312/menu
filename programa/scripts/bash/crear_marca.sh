#!/bin/bash

TIENDA="/tiendas/ElVestidor"

# Mostramos las categorias que tiene la tienda
echo "Categorias disponibles:"
ls "$TIENDA"

# Pedimos la categoria

echo -n "Selecciona la categoria (s para salir): "
read categoria

if [ "$categoria" = "s" ]; then
    exit 0
fi

#Bucle para pedir el nombre de la marca
while true; do
    echo -n "Nombre de la nueva marca (s para salir): "
    read marca

    if [ "$marca" = "s" ]; then
        exit 0
    fi



    # validacion no espacios
    if [[ "$marca" == *" "* ]]; then
        echo "El nombre de la marca no puede contener espacios"
        continue
    fi

    # validacion no empezar por punto
    if [[ "$marca" == .* ]]; then
        echo "El nombre de la marca no puede empezar por punto"
        continue
    fi

    # comprobamos si la marca ya existe
    if [ -d "$TIENDA/$categoria/$marca" ]; then
        echo "ERROR: La marca ya existe"
        continue
    fi
    

    # Creamos la marca
    mkdir "$TIENDA/$categoria/$marca"
    chmod 777 "$TIENDA/$categoria/$marca"

    echo "La marca '$marca' ha sido creada"
    read -n 1 -s -r -p "Pulsa cualquier tecla para continuar..."
    break
done
