#!/bin/bash

# If a song is played by spotify, prepend the title and the artist to i3status

i3status | ( read line; echo "$line"; read line; echo "$line"; read line; echo "$line" ; while true
do 
    read line
    status=$(playerctl status)
    if [[ "$status" == "Playing" ]] || [[ "$status" == "Paused" ]]; then
        title=$(playerctl metadata title)
        artist=$(playerctl metadata artist)
        stat="\"separator\":false,\"min_width\":700,\"align\":\"center\",\"full_text\":\"$title - $artist\"},{"
        echo "${line/[{/[{${stat}}" || exit 1
    else
        echo "$line" || exit 1
    fi
done)
