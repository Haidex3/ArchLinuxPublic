#!/usr/bin/env bash

set -e

# =========================
# Rutas principales
# =========================
SOURCE="$HOME/.config"
TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.config"

# Firefox chrome
FIREFOX_CHROME_SOURCE="$HOME/.mozilla/firefox/s21rhd6v.default-release-1760989103541/chrome"
FIREFOX_CHROME_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/firefox/chrome"

# HaTheme paths
HATHEME_SHARE_SOURCE="$HOME/.local/share/hatheme"
HATHEME_SHARE_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.local/share/hatheme"

# System themes (.local/share/themes)
THEMES_SHARE_SOURCE="$HOME/.local/share/themes"
THEMES_SHARE_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.local/share/themes"

HATHEME_STATE_SOURCE="$HOME/.local/state/hatheme"
HATHEME_STATE_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.local/state/hatheme"

# Scripts
SCRIPTS_SOURCE="$HOME/scripts"
SCRIPTS_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/scripts"

# VS Code
VSCODE_USER_SOURCE="$HOME/.config/Code/User"
VSCODE_USER_TARGET="$HOME/Documents/GitHub/ArchLinuxPublic/.config/Code/User"



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

echo "🔄 Sincronizando dotfiles..."

mkdir -p "$TARGET"

# =========================
# Sync ~/.config/*
# =========================
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

# =========================
# Sync Firefox chrome
# =========================
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

# =========================
# Sync .local/share/themes
# =========================
if [ -d "$THEMES_SHARE_SOURCE" ]; then
    echo "➡️  Sync .local/share/themes"
    mkdir -p "$THEMES_SHARE_TARGET"
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='*.log' \
        "$THEMES_SHARE_SOURCE/" "$THEMES_SHARE_TARGET/"
else
    echo "⚠️  No existe .local/share/themes"
fi


# =========================
# Sync HaTheme (.local/share)
# =========================
if [ -d "$HATHEME_SHARE_SOURCE" ]; then
    echo "➡️  Sync .local/share/hatheme"
    mkdir -p "$HATHEME_SHARE_TARGET"
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='*.log' \
        "$HATHEME_SHARE_SOURCE/" "$HATHEME_SHARE_TARGET/"
else
    echo "⚠️  No existe .local/share/hatheme"
fi

# =========================
# Sync HaTheme (.local/state)
# =========================
if [ -d "$HATHEME_STATE_SOURCE" ]; then
    echo "➡️  Sync .local/state/hatheme"
    mkdir -p "$HATHEME_STATE_TARGET"
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='*.log' \
        "$HATHEME_STATE_SOURCE/" "$HATHEME_STATE_TARGET/"
else
    echo "⚠️  No existe .local/state/hatheme"
fi

# =========================
# Sync ~/scripts
# =========================
if [ -d "$SCRIPTS_SOURCE" ]; then
    echo "➡️  Sync ~/scripts"
    mkdir -p "$SCRIPTS_TARGET"
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='*.log' \
        "$SCRIPTS_SOURCE/" "$SCRIPTS_TARGET/"
else
    echo "⚠️  No existe ~/scripts"
fi

# =========================
# Sync VS Code themes
# =========================
if [ -d "$VSCODE_USER_SOURCE/themes" ]; then
    echo "➡️  Sync VS Code themes"
    mkdir -p "$VSCODE_USER_TARGET/themes"
    rsync -av --delete \
        --exclude='.git/' \
        --exclude='*.log' \
        "$VSCODE_USER_SOURCE/themes/" "$VSCODE_USER_TARGET/themes/"
else
    echo "⚠️  No existe ~/.config/code/user/themes"
fi


# =========================
# Sync VS Code settings.json
# =========================
if [ -f "$VSCODE_USER_SOURCE/settings.json" ]; then
    echo "➡️  Sync VS Code settings.json"
    mkdir -p "$VSCODE_USER_TARGET"
    rsync -av "$VSCODE_USER_SOURCE/settings.json" "$VSCODE_USER_TARGET/settings.json"
else
    echo "⚠️  No existe ~/.config/code/user/settings.json"
fi


echo "✅ Sincronización completa"
