#!/usr/bin/env bash

set -e

# Rutas principales
SOURCE="$HOME/.config"
TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.config"

# Ruta específica de Firefox (chrome)
FIREFOX_CHROME_SOURCE="$HOME/.mozilla/firefox/s21rhd6v.default-release-1760989103541/chrome"
FIREFOX_CHROME_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/firefox/chrome"

# Carpetas a sincronizar desde ~/.config
DIRS=(
alacritty
gtk-3.0
htop
hypr
rofi
waybar
xdg-desktop-portal
yazi
fastfetch
quickshell
)

echo "Sincronizando dotfiles..."

mkdir -p "$TARGET"

# Sync ~/.config/*
for dir in "${DIRS[@]}"; do
if [ -d "$SOURCE/$dir" ]; then
    echo "➡️  Sync ~/.config/$dir"
    rsync -av --delete \
    --exclude='.git/' \
    --exclude='*.log' \
    --exclude='cache/' \
    "$SOURCE/$dir/" "$TARGET/$dir/"
else
    echo "⚠️  $dir no existe en ~/.config"
fi
done

# Sync Firefox chrome
if [ -d "$FIREFOX_CHROME_SOURCE" ]; then
echo "➡️  Sync Firefox chrome"
mkdir -p "$FIREFOX_CHROME_TARGET"
rsync -av --delete \
    --exclude='.git/' \
    --exclude='*.log' \
    "$FIREFOX_CHROME_SOURCE/" "$FIREFOX_CHROME_TARGET/"
else
echo "⚠️  No se encontró la carpeta chrome de Firefox"
fi

echo "✅ Sincronización completa"
