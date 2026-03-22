#!/bin/bash

TIENDA="/tiendas/ElVestidor"
PYTHON_SCRIPT="/home/dam91/programa/scripts/python/editar_producto.py"

# IMPORTANTE: Ejecutar sudo apt install jq si no lo tienes instalado

read -p "Indica la descripción a buscar: " descripcion_buscar

if [[ -z "$descripcion_buscar" ]]; then
    echo "Error: Debes introducir una descripción."
    read -n1 -p "Pulsa una tecla para volver..."
    exit
fi

encontrado=0

for archivo in $(find $TIENDA -name "*.json"); do
    
    desc_archivo=$(jq -r '.descripcion' "$archivo")

    if echo "$desc_archivo" | grep -iq "$descripcion_buscar"; then
        
        codigo=$(basename "$archivo" .json)
        
        nombre=$(jq -r '.nombre' "$archivo")
        descripcion=$(jq -r '.descripcion' "$archivo")
        precio=$(jq -r '.precio' "$archivo")
        stock=$(jq -r '.stock' "$archivo")

        echo "------------------------------------------------"
        echo "Código: $codigo"
        echo "Nombre: $nombre"
        echo "Descripción: $descripcion"
        echo "Precio: $precio"
        echo "Stock: $stock"
        echo "------------------------------------------------"
        
        echo "¿Qué desea hacer?"
        echo "Editar (e), Borrar (b), Volver (v)"
        read -p "Opción: " opcion

        case $opcion in
            e|E)
                read -e -p "Nombre: " -i "$nombre" nuevo_nombre
                read -e -p "Descripción: " -i "$descripcion" nueva_descripcion
                read -e -p "Precio: " -i "$precio" nuevo_precio
                read -e -p "Stock: " -i "$stock" nuevo_stock

                # LLAMADA AL SCRIPT PYTHON CON LA RUTA ABSOLUTA
                python3 "$PYTHON_SCRIPT" "$archivo" "$nuevo_nombre" "$nueva_descripcion" "$nuevo_precio" "$nuevo_stock"
                
                echo "Producto actualizado correctamente."
                read -n1 -p "Pulsa una tecla para continuar..."
                encontrado=1
                ;;
            b|B)
                read -p "¿Realmente deseas eliminar este producto? [S/N]: " conf
                if [ "$conf" = "s" ] || [ "$conf" = "S" ]; then
                    rm "$archivo"
                    echo "Producto eliminado con éxito."
                else
                    echo "Operación cancelada."
                fi
                read -n1 -p "Pulsa una tecla para continuar..."
                encontrado=1
                ;;
            v|V)
                exit 0
                ;;
            *)
                echo "Opción no válida."
                ;;
        esac
    fi
done

if [ $encontrado -eq 0 ]; then
    echo "No se ha encontrado ninguna coincidencia."
    read -n1 -p "Pulsa una tecla para volver..."
fi
