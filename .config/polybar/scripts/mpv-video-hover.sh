#!/bin/bash
# mpv-video-hover.sh - Lightweight video player approach using mpv

FILE_DIR=$(dirname "$0")
MPV_SOCKET="/tmp/mpv-polybar-socket"
PID_FILE="/tmp/mpv-polybar.pid"
VIDEO_URL="${FILE_DIR}/.mpv-video-url"
STATE_FILE="${FILE_DIR}/.mpv-video-state"
SCREEN_WIDTH=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1 | uniq)
MPV_WIDTH=400
MPV_HEIGHT=300
MPV_X=$(($(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1 | uniq) - $MPV_WIDTH))

mpv_running() {
    [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start_mpv() {
    if ! mpv_running; then
        echo "here"
        mpv --no-terminal \
            --geometry=800x600+100+100 \
            --ontop \
            --no-border \
            --autofit=800x600 \
            --loop-playlist=inf \
            --volume=30 \
            --input-ipc-server="$MPV_SOCKET" \
            --log-file="${FILE_DIR}/mpv-video-log" \
            --playlist="${VIDEO_URL}" &
        
        MPV_PID=$!
        echo $MPV_PID > "$PID_FILE"
        
        # Wait a moment for window to appear
        sleep 1
        
        # Set window properties
        WID=$(xdotool search --pid "$MPV_PID" | head -1)
        if [[ -n "$WID" ]]; then
            xdotool windowmove "$WID" 100 100
        fi
    else
        echo "already in running"
        # Show existing window
        if [[ -f "$PID_FILE" ]]; then
            WID=$(xdotool search --pid "$(cat "$PID_FILE")" | head -1)
            [[ -n "$WID" ]] && xdotool windowmap "$WID" windowraise "$WID"
        fi
    fi
    i3-msg "[class=\"mpv\"] floating enable, resize set $MPV_WIDTH $MPV_HEIGHT, move position $MPV_X 50"
    echo 1 > $STATE_FILE
}

hide_mpv() {
    if mpv_running && [[ -f "$PID_FILE" ]]; then
        WID=$(xdotool search --pid "$(cat "$PID_FILE")" | head -1)
        [[ -n "$WID" ]] && xdotool windowunmap "$WID"
    fi
    echo 0 > $STATE_FILE
}

stop_mpv() {
    if mpv_running && [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE" "$MPV_SOCKET"
    fi
}
add_playlist(){
    echo "${*:2}" >> "$VIDEO_URL"
}
new_playlist(){
    echo "${*:2}" > "$VIDEO_URL"
}
streamlink_mpv(){
    if ! mpv_running; then
        echo "running streamlink"
        streamlink --player "mpv" --player-args="--no-terminal --geometry=800x600+100+100 --ontop --no-border --autofit=800x600 --loop-playlist=inf --volume=30 --input-ipc-server=\"$MPV_SOCKET\" --log-file=\"${FILE_DIR}/mpv-video-log\"" ${*:2} &
        STREAMLINK_PID=$!
        
        # Wait for streamlink to launch mpv
        sleep 10
        
        # Find the actual mpv process PID
        MPV_PID=$(pgrep -f "mpv.*$MPV_SOCKET" | tail -1)
        echo "MPV_PID: $MPV_PID"
        if [[ -z "$MPV_PID" ]]; then
            # Fallback: find any mpv process that might be ours
            MPV_PID=$(pgrep mpv | head -1)
        fi
        
        if [[ -n "$MPV_PID" ]]; then
            echo $MPV_PID > "$PID_FILE"
        else
            echo "Warning: Could not find mpv PID, using streamlink PID as fallback"
            echo $STREAMLINK_PID > "$PID_FILE"
        fi
        
        # Wait a moment for window to appear
        sleep 1
        
        # Set window properties
        WID=$(xdotool search --pid "$MPV_PID" | head -1)
        if [[ -n "$WID" ]]; then
            xdotool windowmove "$WID" 100 100
        fi
    else
        echo "already in running"
        # Show existing window
        if [[ -f "$PID_FILE" ]]; then
            WID=$(xdotool search --pid "$(cat "$PID_FILE")" | head -1)
            [[ -n "$WID" ]] && xdotool windowmap "$WID" windowraise "$WID"
        fi
    fi
    i3-msg "[class=\"mpv\"] floating enable, resize set $MPV_WIDTH $MPV_HEIGHT, move position $MPV_X 50"
    echo 1 > $STATE_FILE
}

case "$1" in
    "add")
        add_playlist "$@"
        ;;
    "new")
        new_playlist "$@"
        ;;
    "restart")
        stop_mpv
        start_mpv
        ;;
    "streamlink")
        streamlink_mpv $@
        ;;
    "show")
        start_mpv
        ;;
    "hide")
        hide_mpv
        ;;
    "stop")
        stop_mpv
        ;;
    "toggle")
        if mpv_running; then
            if [[ $(cat $STATE_FILE) == "1" ]]; then
                hide_mpv
            else
                start_mpv
            fi
        else
            start_mpv
        fi
        ;;
    "-h")
        echo "Usage: $0 {add|new|restart|show|hide|stop|toggle}"
        ;;
    *)
        if mpv_running; then
            echo ▶️
        else
            echo 📺
        fi
        exit 1
        ;;
esac
