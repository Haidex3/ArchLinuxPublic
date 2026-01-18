#!/bin/fish

function get-scheme-json -a scheme_dir
    set -l pairs

    # mode
    set -l mode (string trim (cat $scheme_dir/current-mode.txt))
    set pairs $pairs "\"mode\":\"$mode\""

    # colors
    for line in (cat $scheme_dir/current.txt)
        set -l split (string split ' ' $line)

        # ignorar líneas rotas o vacías
        test (count $split) -lt 2 && continue

        set -l key $split[1]
        set -l value $split[2]

        test -z "$key" && continue
        test -z "$value" && continue

        set pairs $pairs "\"$key\":\"#$value\""
    end


    echo -n "{"
    echo -n (string join "," $pairs)
    echo -n "}"
end


# Ruta base del estado
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state

# NUEVO nombre del proyecto
set -l scheme_dir $state/hatheme/scheme

# Script de envío
set -l message (dirname (status filename))/message.sh

# Envío inicial
$message (get-scheme-json $scheme_dir)

# Escuchar cambios
inotifywait -q -e close_write,moved_to,create -m $scheme_dir | while read dir events file
    test "$dir$file" = $scheme_dir/current.txt && $message (get-scheme-json $scheme_dir)
end
