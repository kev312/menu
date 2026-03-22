#!/bin/bash

TIENDA="/tiendas/ElVestidor"

# --- SELECCIÓN DE CATEGORÍA ---
echo "Categorías disponibles:"
ls "$TIENDA"
echo -n "Indica la categoría (s para salir): "
read categoria

if [ "$categoria" = "s" ]; then exit 0; fi
if [ ! -d "$TIENDA/$categoria" ]; then
    echo "Error: Categoría incorrecta."
    read -n 1 -s -r -p "Pulsa una tecla para continuar..."
    exit 1
fi

# --- SELECCIÓN DE MARCA ---
echo "Marcas disponibles en $categoria:"
ls "$TIENDA/$categoria"
echo -n "Indica la marca (s para salir): "
read marca

if [ "$marca" = "s" ]; then exit 0; fi
if [ ! -d "$TIENDA/$categoria/$marca" ]; then
    echo "Error: Marca incorrecta."
    read -n 1 -s -r -p "Pulsa una tecla para continuar..."
    exit 1
fi

# --- CÓDIGO DEL PRODUCTO ---
while true; do
    echo -n "Indica el código del producto (s para salir): "
    read codigo

    if [ "$codigo" = "s" ]; then exit 0; fi

    # Validaciones código
    if [ -z "$codigo" ]; then
        echo "Error: Código vacío."
        continue
    fi

    if [[ "$codigo" =~ [^a-zA-Z0-9] ]]; then
        echo "Error: Solo letras o números."
        continue
    fi

    RUTA="$TIENDA/$categoria/$marca/$codigo.json"

    if [ -f "$RUTA" ]; then
        echo "Error: El código ya existe."
        continue
    fi

    break
done

# --- INTRODUCIR DATOS DEL PRODUCTO ---
echo "------------------------------------------------"
echo "Introduce los datos del producto:"

echo -n "Nombre: "
read nombre

echo -n "Descripción: "
read descripcion

# Validar que el precio sea un número
while true; do
    echo -n "Precio: "
    read precio
    if [[ "$precio" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        break
    else
        echo "Error: El precio debe ser un número válido."
    fi
done

echo -n "Stock: "
read stock

# --- CONFIRMACIÓN ---
echo ""
echo "------------------------------------------------"
echo "RESUMEN DEL PRODUCTO:"
echo "Código: $codigo"
echo "Nombre: $nombre"
echo "Descripción: $descripcion"
echo "Precio: $precio"
echo "Stock: $stock"
echo "------------------------------------------------"
echo -n "¿La información es correcta? [S/N]: "
read confirmacion

if [ "$confirmacion" = "s" ] || [ "$confirmacion" = "S" ]; then
    # --- CREAR ARCHIVO JSON CON LOS DATOS ---
    cat <<EOF > "$RUTA"
{
  "nombre": "$nombre",
  "descripcion": "$descripcion",
  "precio": "$precio",
  "stock": "$stock"
}
EOF

    chmod 666 "$RUTA"
    echo "Producto guardado correctamente."
    read -n 1 -s -r -p "Pulsa una tecla para continuar..."
else
    echo "Operación cancelada."
    read -n 1 -s -r -p "Pulsa una tecla para continuar..."
fi
