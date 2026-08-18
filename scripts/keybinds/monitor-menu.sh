#!/usr/bin/env bash

set -e

CONFIG="$HOME/.config/hypr/configs/monitors.conf"

refresh_monitors() {
    MONITORS_JSON=$(hyprctl monitors -j)

    INTERNAL=$(echo "$MONITORS_JSON" | jq -r \
        '.[] | select(.name | test("^(eDP|LVDS)")) | .name' | head -n1)

    EXTERNAL=$(echo "$MONITORS_JSON" | jq -r \
        '.[] | select(.name != "'"$INTERNAL"'") | .name' | head -n1)

    [[ -z "$INTERNAL" ]] && return 1

    INTERNAL_MODE=$(echo "$MONITORS_JSON" | jq -r \
        '.[] | select(.name=="'"$INTERNAL"'") | "\(.width)x\(.height)@\(.refreshRate|floor)"')

    INTERNAL_WIDTH=$(echo "$MONITORS_JSON" | jq -r \
        '.[] | select(.name=="'"$INTERNAL"'") | .width')

    if [[ -n "$EXTERNAL" ]]; then
        EXTERNAL_MODE=$(echo "$MONITORS_JSON" | jq -r \
            '.[] | select(.name=="'"$EXTERNAL"'") | "\(.width)x\(.height)@\(.refreshRate|floor)"')
    else
        EXTERNAL_MODE=""
    fi
}

OPTIONS=$(
cat <<EOF
󰍹 Solo portátil
󰍺 Duplicar
󰍻 Extender
󰍸 Solo externo
EOF
)

CHOICE=$(echo "$OPTIONS" | rofi -dmenu -i -p "Pantallas")

[[ -z "$CHOICE" ]] && exit 0

if [[ -f "$CONFIG" ]] && grep -Eq ",disable$|,mirror," "$CONFIG"; then
    sed -i -E \
        -e 's/,disable$/,/' \
        -e 's/,mirror,[^,[:space:]]+$//' \
        "$CONFIG"

    hyprctl reload

    for _ in {1..10}; do
        if refresh_monitors; then
            break
        fi
        sleep 0.1
    done
else
    refresh_monitors
fi

if [[ -z "$INTERNAL" ]]; then
    notify-send "Display Manager" "No se encontró monitor interno."
    exit 1
fi

case "$CHOICE" in
    "󰍹 Solo portátil")
        cat > "$CONFIG" <<EOF
# -------------------------------------------------
# Monitor setup (auto-generated)
# -------------------------------------------------

monitor=$INTERNAL,$INTERNAL_MODE,0x0,1
monitor=$EXTERNAL,disable
EOF
        ;;

    "󰍺 Duplicar")
        [[ -z "$EXTERNAL" ]] && exit 0

        cat > "$CONFIG" <<EOF
# -------------------------------------------------
# Monitor setup (auto-generated)
# -------------------------------------------------

monitor=$INTERNAL,$INTERNAL_MODE,0x0,1
monitor=$EXTERNAL,$EXTERNAL_MODE,0x0,1,mirror,$INTERNAL
EOF
EOF
        ;;

    "󰍻 Extender")
        [[ -z "$EXTERNAL" ]] && exit 0

        cat > "$CONFIG" <<EOF
# -------------------------------------------------
# Monitor setup (auto-generated)
# -------------------------------------------------

monitor=$INTERNAL,$INTERNAL_MODE,0x0,1
monitor=$EXTERNAL,$EXTERNAL_MODE,${INTERNAL_WIDTH}x0,1
EOF
        ;;

    "󰍸 Solo externo")
        [[ -z "$EXTERNAL" ]] && exit 0

        cat > "$CONFIG" <<EOF
# -------------------------------------------------
# Monitor setup (auto-generated)
# -------------------------------------------------

monitor=$INTERNAL,disable
monitor=$EXTERNAL,$EXTERNAL_MODE,0x0,1
EOF
        ;;
esac

scripts/scheme/set-wallpaper.sh
hyprctl reload

notify-send "Display Manager" "Configuración aplicada."