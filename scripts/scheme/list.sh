#!/usr/bin/env bash

SCHEME_DIR="/home/Haider/.config/themes"

# Si se pasa un argumento --names, --files
if [[ "$1" == "--names" ]]; then
    for f in "$SCHEME_DIR"/*.txt; do
        basename "$f" .txt
    done
elif [[ "$1" == "--all" ]]; then
    # Muestra los nombres y el contenido de cada archivo
    for f in "$SCHEME_DIR"/*.txt; do
        name=$(basename "$f" .txt)
        echo "=== $name ==="
        cat "$f"
        echo ""
    done
else
    # Por defecto, solo lista los nombres
    echo "Available themes:"
    for f in "$SCHEME_DIR"/*.txt; do
        echo " - $(basename "$f" .txt)"
    done
fi
