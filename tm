#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else

    projects=()

    # Use a while loop with read to populate the array
    while IFS= read -r line; do
      projects+=("$line")
    done < <(find /Users/huntlycameron/Local\ Sites/wordpresstest/app/public/wp-content/themes /Users/huntlycameron/docker/strut-wp/public_html/wordpress.test/wp-content/themes -mindepth 1 -maxdepth 1 -type d)



    selected_proj=$(find {/Users/huntlycameron/Local\ Sites/wordpresstest/app/public/wp-content/themes,/Users/huntlycameron/docker/strut-wp/public_html/wordpress.test/wp-content/themes} -mindepth 1 -maxdepth 1 -type d | xargs -L1 -I{} basename "{}" | gum filter)

    # find selected project in projects array
    for i in "${!projects[@]}"; do
        s=$(basename "${projects[$i]}")
        if [[ "${s}" = "${selected_proj}" ]]; then
            selected=${projects[$i]}
        fi
    done
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    echo "boot tmux up and select session"
    tmux new-session -s $selected_name -c "$selected"
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c "$selected"
fi

tmux switch-client -t $selected_name
