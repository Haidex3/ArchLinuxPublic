#!/usr/bin/env bash

post_sync_adjustments() {

    CONFIG_DIR="$HOME/.config"
    QS_DIR="$CONFIG_DIR/quickshell/services"
    QS_CONF="$CONFIG_DIR/quickshell/modules/bar/components"
    SCRIPTS_DIR="$CONFIG_DIR/scripts"

    echo "Applying post-synchronization adjustments..."

    # =========================================
    # Adjustments ONLY if mode is PULL
    # =========================================
    if [ "$MODE" == "pull" ]; then

        if [ "$IS_LAPTOP" == "true" ]; then
            echo "Laptop profile detected (pull)"

            # Adjust brightness service
            rm -f "$QS_DIR/BrightnessService.qml"

            if [ -f "$QS_DIR/BrightnessPService.qml" ]; then
                mv "$QS_DIR/BrightnessPService.qml" \
                   "$QS_DIR/BrightnessService.qml"
            fi

            rm -f "$QS_CONF/SystemControls.qml"

            if [ -f "$QS_CONF/SystemPControls.qml" ]; then
                mv "$QS_CONF/SystemPControls.qml" \
                   "$QS_CONF/SystemControls.qml"
            fi

            # Remove ddc script (not applicable on laptop)
            rm -f "$SCRIPTS_DIR/brightness-ddc.sh"

        else
            echo "Desktop profile detected (pull)"

            if [ -f "$SCRIPTS_DIR/brightness-ddc.sh" ]; then
                chmod +x "$SCRIPTS_DIR/brightness-ddc.sh"
            fi
        fi

    else
        echo "Push mode detected — no brightness profile files will be modified"
    fi

    # =========================================
    # Always ensure executable permissions
    # =========================================
    if [ -d "$SCRIPTS_DIR" ]; then
        find "$SCRIPTS_DIR" -type f -exec chmod +x {} \;
    fi

    echo "Post-sync adjustments completed"
}
