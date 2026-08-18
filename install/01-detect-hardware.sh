#!/usr/bin/env bash

detect_hardware() {
    IS_LAPTOP=false

    if [ -d /sys/class/power_supply/BAT0 ]; then
        IS_LAPTOP=true
    fi

    export IS_LAPTOP
}
