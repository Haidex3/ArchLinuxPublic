#!/bin/bash

FILE="$HOME/.local/share/commands/communcommands.txt"

# cargar opciones desde el txt
selected=$(cat "$FILE" | rofi -dmenu \
    -p "Commands" \
    -theme ~/.config/rofi/applications.rasi)

# copiar al portapapeles si hay selección
if [[ -n "$selected" ]]; then
    echo -n "$selected" | wl-copy
fi
