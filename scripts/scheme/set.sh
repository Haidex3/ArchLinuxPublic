#!/usr/bin/env bash

# =====================
# Usage: set.sh [theme-name]
# If no theme name is provided, it will show the Rofi selector
# =====================

# =====================
# Base directories
# =====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$HOME/.local/share/hatheme/themes"
STATE_DIR="$HOME/.local/state/hatheme/scheme"
IMG_DIR="$HOME/.local/share/hatheme/images"

mkdir -p "$STATE_DIR"

# =====================
# Function to apply theme
# =====================
apply_theme() {
    local SELECTED="$1"
    
    [[ -z "$SELECTED" ]] && return 1
    
    THEME_FILE="$THEME_DIR/$SELECTED.txt"
    
    if [[ ! -f "$THEME_FILE" ]]; then
        echo "Error: Theme file not found: $THEME_FILE" >&2
        return 1
    fi
    
    # =====================
    # Internal state
    # =====================
    cp "$THEME_FILE" "$STATE_DIR/colors.txt"
    
    printf "%s\n" "$SELECTED" > "$STATE_DIR/current-theme.txt"
    
    MODE="dark"
    [[ "$SELECTED" == *light* ]] && MODE="light"
    printf "%s\n" "$MODE" > "$STATE_DIR/current-mode.txt"
    
    # =====================
    # Export theme variables
    # =====================
    while read -r key value _; do
        [[ -z "$key" || "$key" == \#* ]] && continue
        export "$key=$value"
    done < "$THEME_FILE"
    
    # Apply the theme using the external script
    # CORRECCIÓN: Buscar el script en la ubicación correcta
    # Primero intentar en la ubicación relativa al script
    if [[ -f "$SCRIPT_DIR/../scripts/scheme/apply-theme.sh" ]]; then
        "$SCRIPT_DIR/../scripts/scheme/apply-theme.sh" "$SELECTED"
    elif [[ -f "$HOME/scripts/scheme/apply-theme.sh" ]]; then
        "$HOME/scripts/scheme/apply-theme.sh" "$SELECTED"
    elif [[ -f "$HOME/.config/scripts/scheme/apply-theme.sh" ]]; then
        "$HOME/.config/scripts/scheme/apply-theme.sh" "$SELECTED"
    else
        echo "Warning: apply-theme.sh not found" >&2
        echo "Searched in:" >&2
        echo "  - $SCRIPT_DIR/../scripts/scheme/apply-theme.sh" >&2
        echo "  - $HOME/scripts/scheme/apply-theme.sh" >&2
        echo "  - $HOME/.config/scripts/scheme/apply-theme.sh" >&2
    fi
    
    # =====================
    # GTK settings.ini
    # =====================
    GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
    
    mkdir -p "$(dirname "$GTK_SETTINGS")"
    
    [[ "$SELECTED" == light* ]] && GTK_DARK=0 || GTK_DARK=1
    
    if [[ ! -f "$GTK_SETTINGS" ]]; then
    cat > "$GTK_SETTINGS" <<EOF
[Settings]
gtk-theme-name=$SELECTED
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-application-prefer-dark-theme=$GTK_DARK
EOF
    else
        sed -i \
            -e "s/^gtk-theme-name=.*/gtk-theme-name=$SELECTED/" \
            -e "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/" \
            -e "s/^gtk-font-name=.*/gtk-font-name=Sans 10/" \
            -e "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" \
            "$GTK_SETTINGS"
    fi
    
    # =====================
    # VS Code
    # =====================
    VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    THEME_JSON="$HOME/.config/Code/User/themes/$SELECTED.json"
    
    if [[ -f "$THEME_JSON" ]]; then
        [[ -f "$VSCODE_SETTINGS" ]] || echo "{}" > "$VSCODE_SETTINGS"
        
        TMP_FILE=$(mktemp)
        
        jq \
            --slurpfile theme "$THEME_JSON" '
                del(
                    .["workbench.colorTheme"],
                    .["workbench.colorCustomizations"],
                    .["editor.tokenColorCustomizations"],
                    .["editor.semanticTokenColorCustomizations"]
                )
                * $theme[0]
            ' "$VSCODE_SETTINGS" > "$TMP_FILE" &&
        mv "$TMP_FILE" "$VSCODE_SETTINGS"
    fi
    
    # =====================
    # Yazi
    # =====================
    YAZI_THEMES_DIR="$HOME/.config/yazi/themes"
    YAZI_CONFIG="$HOME/.config/yazi/theme.toml"
    
    mkdir -p "$(dirname "$YAZI_CONFIG")"
    
    YAZI_THEME_FILE="$YAZI_THEMES_DIR/$SELECTED.toml"
    
    [[ -f "$YAZI_THEME_FILE" ]] && cp "$YAZI_THEME_FILE" "$YAZI_CONFIG"
    
    # =====================
    # Rofi
    # =====================
    ROFI_THEMES_DIR="$HOME/.config/rofi/themes"
    ROFI_CURRENT_THEME="$ROFI_THEMES_DIR/current-theme.rasi"
    ROFI_SELECTED_THEME="$ROFI_THEMES_DIR/$SELECTED.rasi"
    
    mkdir -p "$ROFI_THEMES_DIR"
    
    [[ -f "$ROFI_SELECTED_THEME" ]] && cp "$ROFI_SELECTED_THEME" "$ROFI_CURRENT_THEME"
    
    # =====================
    # GTK refresh
    # =====================
    gsettings set org.gnome.desktop.interface gtk-theme "$SELECTED" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name "Sans 10" 2>/dev/null || true
    
    # =====================
    # Spicetify (optional)
    # =====================
    if command -v spicetify &> /dev/null; then
        spicetify config current_theme "$SELECTED" 2>/dev/null || true
        spicetify config color_scheme "$SELECTED" 2>/dev/null || true
        spicetify apply --no-restart 2>/dev/null || true
    fi
    
    echo "Theme applied: $SELECTED"
    return 0
}

# =====================
# Main execution
# =====================

# If a theme name is passed as argument, apply it directly
if [[ $# -gt 0 ]]; then
    apply_theme "$1"
    exit $?
fi

# =====================
# Interactive mode (Rofi selector)
# =====================

# List themes
THEMES=()

for file in "$THEME_DIR"/*.txt; do
    [[ -e "$file" ]] || continue
    THEMES+=("${file##*/}")
    THEMES[-1]="${THEMES[-1]%.txt}"
done

if [[ ${#THEMES[@]} -eq 0 ]]; then
    echo "No themes found in $THEME_DIR" >&2
    exit 1
fi

ENTRIES=()
for theme in "${THEMES[@]}"; do
    icon="$IMG_DIR/$theme.png"
    if [[ -f "$icon" ]]; then
        ENTRIES+=("$theme\x00icon\x1f$icon")
    else
        ENTRIES+=("$theme")
    fi
done

SELECTED=$(
    printf "%b\n" "${ENTRIES[@]}" |
        rofi -dmenu \
            -i \
            -p "Select Theme" \
            -theme "$HOME/.config/rofi/scheme-selector.rasi" \
            -show-icons
)

[[ -z "$SELECTED" ]] && exit 0

apply_theme "$SELECTED"