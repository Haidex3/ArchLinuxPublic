#!/usr/bin/env bash

IMG_DIR="$HOME/.local/share/hatheme/images"
STATE_DIR="$HOME/.local/state/hatheme/scheme"

if [[ -n "$1" ]]; then
    THEME="$1"
elif [[ -f "$STATE_DIR/current-theme.txt" ]]; then
    read -r THEME < "$STATE_DIR/current-theme.txt"
else
    exit 1
fi

WALLPAPER="$IMG_DIR/$THEME.png"
WALLPAPER_M2="$IMG_DIR/${THEME}-M2.png"

[[ -f "$WALLPAPER" ]] || exit 1

mapfile -t MONITORS < <(
    hyprctl monitors -j | jq -r '.[].name'
)

awww img "$WALLPAPER" \
    --outputs "${MONITORS[0]}" --transition-type none

[[ -n "${MONITORS[1]}" && -f "$WALLPAPER_M2" ]] &&
    awww img "$WALLPAPER_M2" --outputs "${MONITORS[1]}" --transition-type none