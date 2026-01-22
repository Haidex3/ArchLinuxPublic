#!/usr/bin/env bash

# ----------------------------
# Rutas
# ----------------------------
COLOR_FILE="$HOME/.local/state/hatheme/scheme/colors.txt"

# Alacritty
ALACRITTY_CONFIG="$HOME/.config/alacritty/colors.toml"
# Kitty
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"
# Rofi
ROFI_CONFIG="$HOME/.config/rofi/colors.rasi"
# VS Code (Code)
#VSCODE_CONFIG="$HOME/.config/Code/User/settings.json"
# Yazi terminal (ejemplo)
YAZI_CONFIG="$HOME/.config/yazi/config.yml"

# ----------------------------
# Leer colores del archivo maestro
# ----------------------------
get_color() {
    grep "^$1" "$COLOR_FILE" | awk '{print "#"$2}'
}

primary=$(get_color "primary_paletteKeyColor")
secondary=$(get_color "secondary_paletteKeyColor")
background=$(get_color "background")
foreground=$(get_color "onBackground")
cursor=$(get_color "primary")
success=$(get_color "success")
error=$(get_color "error")
warning=$(get_color "yellow")
info=$(get_color "blue")

# ----------------------------
# Generar Alacritty config
# ----------------------------
cat > "$ALACRITTY_CONFIG" <<EOF
[colors]

[colors.primary]
  background= "$background"
  foreground= "$foreground"

EOF

# ----------------------------
# Generar Kitty config
# ----------------------------
cat > "$KITTY_CONFIG" <<EOF
background $background
foreground $foreground
cursor $cursor
color0 $background
color1 $error
color2 $success
color3 $warning
color4 $info
color5 $primary
color6 $secondary
color7 $foreground
EOF

# ----------------------------
# Generar Rofi colors
# ----------------------------
cat > "$ROFI_CONFIG" <<EOF
* {
    bg: $background;
    fg: $foreground;
    selected-bg: $primary;
    selected-fg: $foreground;
    urgent-bg: $error;
    urgent-fg: $foreground;
}
EOF

# ----------------------------
# Generar VS Code theme (solo colores básicos)
# ----------------------------
#mkdir -p "$(dirname "$VSCODE_CONFIG")"
#cat > "$VSCODE_CONFIG" <<EOF
#{
#    "workbench.colorCustomizations": {
#        "editor.background": "$background",
#        "editor.foreground": "$foreground",
#        "editorCursor.foreground": "$cursor",
#        "activityBar.background": "$primary",
#        "sideBar.background": "$secondary",
#        "statusBar.background": "$primary",
#        "titleBar.activeBackground": "$primary"
#    }
#}
#EOF

# ----------------------------
# Generar Yazi terminal config (ejemplo)
# ----------------------------
mkdir -p "$(dirname "$YAZI_CONFIG")"
cat > "$YAZI_CONFIG" <<EOF
colors:
  background: "$background"
  foreground: "$foreground"
  cursor: "$cursor"
  primary: "$primary"
  secondary: "$secondary"
  success: "$success"
  error: "$error"
  warning: "$warning"
  info: "$info"
EOF

echo "✅ Tema aplicado desde $COLOR_FILE a todas las apps compatibles."
