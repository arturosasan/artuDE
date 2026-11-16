#!/usr/bin/env bash
#
# SwayNC notification hook: persistent JSONL history + sound.
# SwayNC only executes the first matching script, so this script does both.
# Notification data is passed through the SWAYNC_* environment variables.

set -u

# Re-exec detached so SwayNC never waits on disk I/O or the sound player.
if [[ -z ${SWAYNC_HOOK_DETACHED:-} ]]; then
    SWAYNC_HOOK_DETACHED=1 setsid -f "$0" "$@" >/dev/null 2>&1
    exit 0
fi

# Notifications that replace an existing one are updates (progress bars, etc.).
if [[ ${SWAYNC_REPLACES_ID:-0} != 0 ]]; then
    exit 0
fi

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/swaync"
mkdir -p "$state_dir"
history="$state_dir/history.jsonl"

clean() {
    if [[ $1 == "(null)" ]]; then
        printf ''
    else
        printf '%s' "$1"
    fi
}

# Keep the history bounded (5 MiB).
if [[ -f $history ]] && (( $(stat -c%s "$history" 2>/dev/null || echo 0) > 5242880 )); then
    tail -n 2000 "$history" > "$history.tmp" 2>/dev/null && mv "$history.tmp" "$history"
fi

# Append one JSON object per notification.
jq -cn \
    --arg time "$(date -Is)" \
    --arg app "$(clean "${SWAYNC_APP_NAME:-}")" \
    --arg desktop_entry "$(clean "${SWAYNC_DESKTOP_ENTRY:-}")" \
    --arg summary "$(clean "${SWAYNC_SUMMARY:-}")" \
    --arg body "$(clean "${SWAYNC_BODY:-}")" \
    --arg urgency "$(clean "${SWAYNC_URGENCY:-Normal}")" \
    --arg category "$(clean "${SWAYNC_CATEGORY:-}")" \
    --arg id "$(clean "${SWAYNC_ID:-0}")" \
    '{time: $time, app: $app, desktop_entry: $desktop_entry, summary: $summary, body: $body, urgency: $urgency, category: $category, id: $id}' \
    >> "$history" 2>/dev/null || true

# Respect apps that explicitly ask for silence.
if [[ ${SWAYNC_HINT_SUPPRESS_SOUND:-false} == "true" ]]; then
    exit 0
fi

# Do Not Disturb: keep the history, skip the sound.
if [[ "$(swaync-client -D -sw 2>/dev/null)" == "true" ]]; then
    exit 0
fi

# Low urgency is usually a volume/brightness OSD: stay silent.
case "${SWAYNC_URGENCY:-Normal}" in
    Low|low) exit 0 ;;
esac

# Per-app exceptions (app name -> silent).
case "${SWAYNC_APP_NAME:-}" in
    Spotify|spotify|swayosd|swayosd-server) exit 0 ;;
esac

# Sound selection.
case "${SWAYNC_URGENCY:-Normal}" in
    Critical|critical) sound="dialog-warning" ;;
    *) sound="message-new-instant" ;;
esac

# Honour a sound file requested by the application when it exists.
sound_file=""
if [[ -n ${SWAYNC_SOUND_FILE:-} && -f ${SWAYNC_SOUND_FILE} ]]; then
    sound_file="$SWAYNC_SOUND_FILE"
fi

# Debounce bursts (several notifications arriving together).
stamp="${XDG_RUNTIME_DIR:-/tmp}/swaync-sound.last"
now=$(date +%s%3N)
last=$(cat "$stamp" 2>/dev/null || printf '0')
if (( now - last < 400 )); then
    exit 0
fi
printf '%s\n' "$now" > "$stamp" 2>/dev/null || true

sound_path="/usr/share/sounds/freedesktop/stereo/${sound}.oga"

if command -v canberra-gtk-play >/dev/null 2>&1; then
    if [[ -n $sound_file ]]; then
        canberra-gtk-play -f "$sound_file" >/dev/null 2>&1 && exit 0
    else
        canberra-gtk-play -i "$sound" >/dev/null 2>&1 && exit 0
    fi
fi

if [[ -f $sound_path ]] && command -v paplay >/dev/null 2>&1; then
    paplay "$sound_path" >/dev/null 2>&1 || true
elif [[ -f $sound_path ]] && command -v pw-play >/dev/null 2>&1; then
    pw-play "$sound_path" >/dev/null 2>&1 || true
fi

exit 0
