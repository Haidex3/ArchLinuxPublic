#!/usr/bin/env bash

CLASS="org.pulseaudio.pavucontrol"

# Lanzar pavucontrol
pavucontrol &

PAVU_PID=$!

# Esperar a que Hyprland mapee la ventana
sleep 2

# Loop de enfoque: cerrar al perder foco
while true; do
    ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class' 2>/dev/null)
    # Si la ventana activa ya no es pavucontrol, matar el proceso y salir
    [[ "$ACTIVE_CLASS" != "$CLASS" ]] && kill "$PAVU_PID" 2>/dev/null && exit 0
    sleep 0.2
done
