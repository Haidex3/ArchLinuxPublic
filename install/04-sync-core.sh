#!/usr/bin/env bash

sync_dir() {
    local SRC="$1"
    local DST="$2"
    local DESC="$3"

    if [ -e "$SRC" ]; then
        echo "Sync $DESC"
        mkdir -p "$DST"

        EXCLUDES=(
            --exclude='.git/'
            --exclude='*.log'
            --exclude='cache/'
        )

        if [ "$MODE" != "pull" ] && [ "$IS_LAPTOP" == "true" ]; then
            EXCLUDES+=(
                --exclude='quickshell/services/BrightnessPService.qml'
                --exclude='quickshell/services/BrightnessService.qml'
                --exclude='quickshell/modules/bar/components/SystemControls.qml'
                --exclude='quickshell/modules/bar/components/SystemPControls.qml'
            )
        fi

        rsync -av --delete "${EXCLUDES[@]}" \
            "$SRC/" "$DST/"
    else
        echo "$DESC does not exist ($SRC)"
    fi
}
