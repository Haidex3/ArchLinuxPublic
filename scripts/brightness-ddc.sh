#!/usr/bin/env bash


BUS="2"
STEP=10
MAX=100

current=$(ddcutil getvcp 10 --bus=$BUS | grep -oP 'current value =\s*\K[0-9]+')
if [[ -z "$current" ]]; then
    echo "No se pudo obtener el brillo actual."
    exit 1
fi

if [[ "$1" == "up" ]]; then
    new=$(( current + STEP ))
elif [[ "$1" == "down" ]]; then
    new=$(( current - STEP ))
else
    echo "Uso: $0 up|down"
    exit 1
fi

if (( new > MAX )); then new=$MAX; fi
if (( new < 0 )); then new=0; fi

ddcutil setvcp 10 "$new" --bus=$BUS >/dev/null 2>&1
