#!/bin/fish

# Función: genera JSON desde los archivos de colores
function get-scheme-json -a scheme_dir
    set -l pairs

    # mode
    set -l mode (string trim (cat $scheme_dir/current-mode.txt))
    set pairs $pairs "\"mode\":\"$mode\""

    # colors
    for line in (cat $scheme_dir/current.txt)
        set -l split (string split ' ' $line)
        test (count $split) -lt 2; and continue
        set -l key $split[1]
        set -l value $split[2]
        test -z "$key"; and continue
        test -z "$value"; and continue
        set pairs $pairs "\"$key\":\"#$value\""
    end

    echo "{ " (string join "," $pairs) " }"
end

# Ruta base del estado
set -q XDG_STATE_HOME; and set -l state $XDG_STATE_HOME; or set -l state $HOME/.local/state
set -l scheme_dir $state/hatheme/scheme

# Envío inicial
~/scripts/firefox/message.sh (get-scheme-json $scheme_dir)

# Escuchar cambios y reenviar JSON
inotifywait -q -e close_write,moved_to,create -m $scheme_dir | while read dir events file
    test "$dir$file" = $scheme_dir/current.txt; and ~/scripts/firefox/message.sh (get-scheme-json $scheme_dir)
end
