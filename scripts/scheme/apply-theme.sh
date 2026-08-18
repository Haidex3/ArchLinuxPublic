#!/usr/bin/env bash

# ----------------------------
# Paths
# ----------------------------
SELECTED="$1"
COLOR_FILE="$HOME/.local/state/hatheme/scheme/colors.txt"

ALACRITTY_CONFIG="$HOME/.config/alacritty/colors.toml"
ALACRITTY_NMTUI_CONFIG="$HOME/.config/alacritty/nmtui.toml"
ALACRITTY_BLUETUI_CONFIG="$HOME/.config/alacritty/bluetui.toml"

FIREFOX_PROFILE="$HOME/.mozilla/firefox/wq4xww1n.default-release"
CHROME_DIR="$FIREFOX_PROFILE/chrome"
HATHEME_CSS="$CHROME_DIR/hatheme-state.css"

KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"
HYPR_COLORS="$HOME/.config/hypr/myColors.conf"

# ----------------------------
# Load colors once
# ----------------------------
declare -A COLORS

while read -r key value _; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    COLORS["$key"]="#$value"
done < "$COLOR_FILE"

primary="${COLORS[primary_paletteKeyColor]}"
secondary="${COLORS[secondary_paletteKeyColor]}"
background="${COLORS[background]}"
foreground="${COLORS[onBackground]}"
cursor="${COLORS[primary]}"
success="${COLORS[success]}"
error="${COLORS[error]}"
warning="${COLORS[yellow]}"
info="${COLORS[blue]}"
primaryContainer="${COLORS[primaryContainer]}"

active_border="rgba(${primary#\#}ff)"

# ----------------------------
# Ensure directories exist
# ----------------------------
mkdir -p \
    "$(dirname "$ALACRITTY_CONFIG")" \
    "$(dirname "$KITTY_CONFIG")" \
    "$(dirname "$HYPR_COLORS")" \
    "$CHROME_DIR"

# ----------------------------
# Alacritty
# ----------------------------
cat > "$ALACRITTY_CONFIG" <<EOF
[colors]

[colors.primary]
background = "$background"
foreground = "$foreground"
EOF

# ----------------------------
# nmtui
# ----------------------------
cat > "$ALACRITTY_NMTUI_CONFIG" <<EOF
[colors.normal]
black = "$primary"
red = "$secondary"
blue = "$background"
white = "$background"
EOF

# ----------------------------
# bluetui
# ----------------------------
cat > "$ALACRITTY_BLUETUI_CONFIG" <<EOF
[colors.normal]
black = "$background"
green = "$primary"
yellow = "$secondary"
blue = "$secondary"

[colors.primary]
foreground = "$primary"
background = "$background"

[colors.bright]
white = "$primary"
black = "$primaryContainer"
EOF

# ----------------------------
# Kitty
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
# Hyprland
# ----------------------------
cat > "$HYPR_COLORS" <<EOF
general {
    col.active_border = $active_border
}
EOF

# ----------------------------
# Firefox
# ----------------------------
cat > "$HATHEME_CSS" <<EOF
/* Auto-generated – DO NOT EDIT */
@-moz-document url("about:home"), url("about:newtab") {
    :root {
        --hatheme-theme: $SELECTED;
        --wallpaper-current: url("images/${SELECTED}.png");
    }
}

::selection,
::-moz-selection,
*::selection,
*::-moz-selection,
html ::selection,
html ::-moz-selection,
body ::selection,
body ::-moz-selection {
    background: $primary !important;
    color: $background !important;
}
EOF

scripts/scheme/set-wallpaper.sh "$SELECTED"
hyprctl reload