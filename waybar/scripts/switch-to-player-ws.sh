#!/bin/bash

player=$(playerctl -l 2>/dev/null | head -1)
[ -z "$player" ] && exit 0

mpris_pid=$(dbus-send --session --dest=org.freedesktop.DBus \
  --type=method_call --print-reply \
  /org/freedesktop/DBus org.freedesktop.DBus.GetConnectionUnixProcessID \
  "string:org.mpris.MediaPlayer2.$player" 2>/dev/null | grep -oP 'uint32\s+\K\d+')
mpris_pid=${mpris_pid:-0}

ws=$(hyprctl clients -j 2>/dev/null | python3 -c "
import json, sys, re

full = '$player'
mpris_pid = $mpris_pid
clients = json.load(sys.stdin)

# 0. MPRIS PID matching (most reliable: Zen Browser, Firefox forks)
if mpris_pid:
    for c in clients:
        if c.get('pid') == mpris_pid:
            print(c['workspace']['id'])
            sys.exit(0)
    try:
        with open(f'/proc/{mpris_pid}/status') as f:
            for line in f:
                if line.startswith('PPid:'):
                    ppid = int(line.split()[1])
                    break
        for c in clients:
            if c.get('pid') == ppid:
                print(c['workspace']['id'])
                sys.exit(0)
    except:
        pass

# 1. PID matching (Electron apps: Pear Desktop, etc.)
match = re.search(r'(?:\.instance|\.)(\d+)$', full)
if match:
    target_pid = int(match.group(1))
    for c in clients:
        if c.get('pid') == target_pid:
            print(c['workspace']['id'])
            sys.exit(0)

# 2. Name matching fallback (Spotify, etc.)
player_lower = full.lower()
for c in clients:
    cls = c.get('class', '').lower()
    title = c.get('title', '').lower()
    if player_lower in cls or player_lower in title:
        print(c['workspace']['id'])
        sys.exit(0)
")

[ -n "$ws" ] && hyprctl dispatch 'hl.dsp.focus({ workspace = '$ws' })'
