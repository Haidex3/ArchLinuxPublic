#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/Haider/.Xauthority

sleep 10

while true; do
    if ! nvidia-smi > /dev/null 2>&1; then
        echo "Error: nvidia-smi no disponible"
        sleep 30
        continue
    fi

    TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    
    if [ -z "$TEMP" ] || [ "$TEMP" -lt 0 ] || [ "$TEMP" -gt 100 ]; then
        echo "Error: Temperatura inválida: $TEMP"
        sleep 10
        continue
    fi

    if [ "$TEMP" -lt 20 ]; then
        SPEED=30
    elif [ "$TEMP" -lt 25 ]; then
        SPEED=45
    elif [ "$TEMP" -lt 30 ]; then
        SPEED=60
    elif [ "$TEMP" -lt 35 ]; then
        SPEED=75
    else
        SPEED=90
    fi

    echo "Temperatura: ${TEMP}°C - Velocidad ventilador: ${SPEED}%"

    env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
        nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \
        -a "[fan:0]/GPUTargetFanSpeed=${SPEED}"

    sleep 10
done
