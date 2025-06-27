#!/bin/bash

# video-hover.sh - Script to show/hide browser with video on hover

BROWSER_CLASS="video-browser"
VIDEO_URL="https://www.youtube.com/watch?v=YOUR_VIDEO_ID"
BROWSER_CMD="firefox"  # or chromium, google-chrome, etc.

# Function to check if browser window exists
browser_exists() {
    xdotool search --class "$BROWSER_CLASS" > /dev/null 2>&1
}

# Function to show browser
show_browser() {
    if browser_exists; then
        # Window exists, just show it
        xdotool search --class "$BROWSER_CLASS" windowmap windowraise
    else
        # Create new browser window
        $BROWSER_CMD --class="$BROWSER_CLASS" \
                     --new-window \
                     --window-size=800,600 \
                     --window-position=100,100 \
                     "$VIDEO_URL" &
        
        # Wait for window to appear and set properties
        sleep 2
        if browser_exists; then
            WID=$(xdotool search --class "$BROWSER_CLASS" | head -1)
            # Make window floating and set position
            xdotool windowmove "$WID" 100 100
            xdotool windowsize "$WID" 800 600
        fi
    fi
}

# Function to hide browser
hide_browser() {
    if browser_exists; then
        xdotool search --class "$BROWSER_CLASS" windowunmap
    fi
}

# Main logic
case "$1" in
    "show")
        show_browser
        ;;
    "hide")
        hide_browser
        ;;
    "toggle")
        if browser_exists && xdotool search --class "$BROWSER_CLASS" | xargs xdotool getwindowgeometry | grep -q "Position"; then
            hide_browser
        else
            show_browser
        fi
        ;;
    *)
        echo "Usage: $0 {show|hide|toggle}"
        exit 1
        ;;
esac
