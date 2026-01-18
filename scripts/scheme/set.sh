#!/usr/bin/env bash

# Directorios
THEME_DIR="$HOME/.local/share/hatheme/themes"
STATE_DIR="$HOME/.local/state/hatheme/scheme"
IMG_DIR="$HOME/.local/share/hatheme/images"

# Crear carpeta de estado si no existe
mkdir -p "$STATE_DIR"

# --- Listar temas ---
THEMES=($(ls "$THEME_DIR"/*.txt | xargs -n 1 basename | sed 's/\.txt$//'))

ENTRIES=()

for theme in "${THEMES[@]}"; do
    icon="$IMG_DIR/$theme.png"

    if [[ -f "$icon" ]]; then
        ENTRIES+=("$theme\x00icon\x1f$icon")
    else
        ENTRIES+=("$theme")
    fi
done

SELECTED=$(printf "%b\n" "${ENTRIES[@]}" | \
    rofi -dmenu -i -p "Select Theme" \
         -theme "$HOME/.config/rofi/scheme-selector.rasi" \
         -show-icons)


# Si no seleccionó nada
if [[ -z "$SELECTED" ]]; then
    echo "No theme selected."
    exit 1
fi

THEME_FILE="$THEME_DIR/$SELECTED.txt"

# --- Copiar el tema seleccionado a current.txt ---
cp "$THEME_FILE" "$STATE_DIR/current.txt"
echo "Applied theme '$SELECTED' to current.txt"

# --- Determinar el modo ---
MODE="dark"
[[ "$SELECTED" == *"light"* ]] && MODE="light"
echo "$MODE" > "$STATE_DIR/current-mode.txt"
echo "Set mode to '$MODE' in current-mode.txt"

# --- Exportar variables al shell ---
while read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    key=$(echo "$line" | awk '{print $1}')
    value=$(echo "$line" | awk '{print $2}')
    export "$key=$value"
done < "$THEME_FILE"

echo "Theme variables exported to shell."
