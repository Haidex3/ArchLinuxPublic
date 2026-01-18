#!/bin/bash
# message.sh: envía JSON a Firefox Native Messaging con header de 4 bytes

json="$1"

# calcular longitud del JSON en bytes
len=$(printf "%s" "$json" | wc -c)

# escribir 4 bytes little-endian + JSON
printf "%b" "$(printf '\\x%02x\\x%02x\\x%02x\\x%02x' \
    $((len & 0xFF)) \
    $(((len >> 8) & 0xFF)) \
    $(((len >> 16) & 0xFF)) \
    $(((len >> 24) & 0xFF)))" > /dev/stdout

printf "%s" "$json" > /dev/stdout
