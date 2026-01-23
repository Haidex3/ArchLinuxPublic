#!/usr/bin/env bash

# =====================
# Directorios base
# =====================
THEME_DIR="$HOME/.local/share/hatheme/themes"
STATE_DIR="$HOME/.local/state/hatheme/scheme"
IMG_DIR="$HOME/.local/share/hatheme/images"

FIREFOX_PROFILE="$HOME/.mozilla/firefox/s21rhd6v.default-release-1760989103541"
CHROME_DIR="$FIREFOX_PROFILE/chrome"
HATHEME_CSS="$CHROME_DIR/hatheme-state.css"

# Crear carpetas necesarias
mkdir -p "$STATE_DIR"
mkdir -p "$CHROME_DIR"

# =====================
# Listar temas
# =====================
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

# Cancelado
[[ -z "$SELECTED" ]] && exit 0

THEME_FILE="$THEME_DIR/$SELECTED.txt"

# =====================
# Estado interno
# =====================
cp "$THEME_FILE" "$STATE_DIR/colors.txt"
echo "$SELECTED" > "$STATE_DIR/current-theme.txt"

MODE="dark"
[[ "$SELECTED" == *"light"* ]] && MODE="light"
echo "$MODE" > "$STATE_DIR/current-mode.txt"


cat > "$HATHEME_CSS" <<EOF
/* Auto-generated – DO NOT EDIT */
@-moz-document url("about:home"), url("about:newtab") {
    :root {
        --hatheme-theme: $SELECTED;
        --wallpaper-current: url("images/$SELECTED.png");
    }
}
EOF

echo "Firefox theme state written to hatheme-state.css"

# =====================
# Exportar variables del tema
# =====================
while read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    key=$(echo "$line" | awk '{print $1}')
    value=$(echo "$line" | awk '{print $2}')
    export "$key=$value"
done < "$THEME_FILE"

# =====================
# Wallpaper (swww)
# =====================
WALLPAPER="$IMG_DIR/$SELECTED.png"
WALLPAPER_M2="$IMG_DIR/$SELECTED-M2.png"

if [[ -f "$WALLPAPER" ]]; then
    swww img "$WALLPAPER" --outputs HDMI-A-1
    [[ -f "$WALLPAPER_M2" ]] && swww img "$WALLPAPER_M2" --outputs HDMI-A-3
fi

echo "Theme '$SELECTED' applied successfully."


scripts/scheme/apply-theme.sh

GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

mkdir -p "$(dirname "$GTK_SETTINGS")"

# Crear archivo si no existe
if [[ ! -f "$GTK_SETTINGS" ]]; then
cat > "$GTK_SETTINGS" <<EOF
[Settings]
gtk-theme-name=$SELECTED
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-application-prefer-dark-theme=1
EOF
else
    # Reemplazos seguros
    sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$SELECTED/" "$GTK_SETTINGS" \
        || echo "gtk-theme-name=$SELECTED" >> "$GTK_SETTINGS"

    sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/" "$GTK_SETTINGS" \
        || echo "gtk-icon-theme-name=Papirus-Dark" >> "$GTK_SETTINGS"

    sed -i "s/^gtk-font-name=.*/gtk-font-name=Sans 10/" "$GTK_SETTINGS" \
        || echo "gtk-font-name=Sans 10" >> "$GTK_SETTINGS"

    sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/" "$GTK_SETTINGS" \
        || echo "gtk-application-prefer-dark-theme=1" >> "$GTK_SETTINGS"
fi

# =====================
# GTK refresh
# =====================
gsettings set org.gnome.desktop.interface gtk-theme "$SELECTED"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings set org.gnome.desktop.interface font-name "Sans 10"

