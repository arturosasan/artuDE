#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
    echo '{"text": "", "class": "stopped"}'
    exit 0
fi

artist=$(playerctl metadata --format "{{artist}}" 2>/dev/null)
title=$(playerctl metadata --format "{{title}}" 2>/dev/null)

if [ -z "$artist" ]; then artist=""; fi
if [ -z "$title" ]; then title=""; fi

if [ ${#title} -gt 28 ]; then
    title="${title:0:28}..."
fi
if [ ${#artist} -gt 22 ]; then
    artist="${artist:0:22}..."
fi

if [ "$status" = "Playing" ]; then
    icon=""
    class="playing"
elif [ "$status" = "Paused" ]; then
    icon=""
    class="paused"
else
    icon=""
    class="stopped"
fi

if [ -n "$artist" ]; then
    text="$icon $artist - $title"
else
    text="$icon $title"
fi

echo "{\"text\": \"$text\", \"class\": \"$class\"}"
