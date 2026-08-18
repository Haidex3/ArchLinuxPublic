#!/usr/bin/env bash

setup_paths() {

    set -e

    echo "Checking firefox binary..."
    if ! command -v firefox &>/dev/null; then
        echo "Firefox installation failed"
        exit 1
    fi

    echo "Running Firefox headless to generate profile..."
    firefox --headless &>/dev/null &
    FIREFOX_PID=$!

    sleep 5

    kill "$FIREFOX_PID" &>/dev/null || true
    sleep 2

    SOURCE="$HOME/.config"
    TARGET="$REPO_ROOT/.config"

    POSSIBLE_DIRS=(
        "$HOME/.mozilla/firefox"
        "$HOME/.config/mozilla/firefox"
    )

    FIREFOX_DIR=""
    PROFILE_INI=""

    for dir in "${POSSIBLE_DIRS[@]}"; do
        if [ -f "$dir/profiles.ini" ]; then
            FIREFOX_DIR="$dir"
            PROFILE_INI="$dir/profiles.ini"
            break
        fi
    done

    if [ -z "$PROFILE_INI" ]; then
        echo "profiles.ini not found"
        exit 1
    fi

    DEFAULT_PROFILE=$(awk -F= '
        $1=="Default" && $2=="1" { found=1 }
        found && $1=="Path" { print $2; exit }
    ' "$PROFILE_INI")

    if [ -z "$DEFAULT_PROFILE" ]; then
        DEFAULT_PROFILE=$(grep -m1 "^Path=" "$PROFILE_INI" | cut -d= -f2)
    fi

    if [ -z "$DEFAULT_PROFILE" ]; then
        echo "Could not determine default profile"
        exit 1
    fi

    PROFILE_PATH="$FIREFOX_DIR/$DEFAULT_PROFILE"
    FIREFOX_CHROME_SOURCE="$PROFILE_PATH/chrome"
    mkdir -p "$FIREFOX_CHROME_SOURCE"

    FIREFOX_CHROME_TARGET="$REPO_ROOT/firefox/chrome"

    # ----------------------------
    # Firefox native messaging
    # ----------------------------

    FIREFOX_NATIVE_SOURCE="$HOME/.mozilla/native-messaging-hosts"
    FIREFOX_NATIVE_TARGET="$REPO_ROOT/.mozilla/native-messaging-hosts"

    HATHEME_SHARE_SOURCE="$HOME/.local/share/hatheme"
    HATHEME_SHARE_TARGET="$REPO_ROOT/.local/share/hatheme"

    THEMES_SHARE_SOURCE="$HOME/.local/share/themes"
    THEMES_SHARE_TARGET="$REPO_ROOT/.local/share/themes"

    HATHEME_STATE_SOURCE="$HOME/.local/state/hatheme"
    HATHEME_STATE_TARGET="$REPO_ROOT/.local/state/hatheme"

    SCRIPTS_SOURCE="$HOME/scripts"
    SCRIPTS_TARGET="$REPO_ROOT/scripts"

    VSCODE_USER_SOURCE="$HOME/.config/Code/User"
    VSCODE_USER_TARGET="$REPO_ROOT/.config/Code/User"

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
        spicetify
    )

    # ----------------------------
    # GRUB configuration
    # ----------------------------

    GRUB_SOURCE="$REPO_ROOT/Grub/grub"
    GRUB_TARGET="/etc/default/grub"

    GRUB_THEME_SOURCE="$REPO_ROOT/Grub/minegrub-world-selection"
    GRUB_THEME_TARGET="/boot/grub/themes/minegrub-world-selection"

    # ----------------------------
    # Unified export
    # ----------------------------

    export SOURCE TARGET \
        FIREFOX_CHROME_SOURCE FIREFOX_CHROME_TARGET \
        FIREFOX_NATIVE_SOURCE FIREFOX_NATIVE_TARGET \
        HATHEME_SHARE_SOURCE HATHEME_SHARE_TARGET \
        THEMES_SHARE_SOURCE THEMES_SHARE_TARGET \
        HATHEME_STATE_SOURCE HATHEME_STATE_TARGET \
        SCRIPTS_SOURCE SCRIPTS_TARGET \
        VSCODE_USER_SOURCE VSCODE_USER_TARGET \
        GRUB_SOURCE GRUB_TARGET \
        GRUB_THEME_SOURCE GRUB_THEME_TARGET \
        DIRS
}