#!/bin/bash
alias display_laptop_brightness="xrandr --output eDP-1 --brightness"
alias display_hdmi_brightness="xrandr --output HDMI-1 --brightness"
alias display_enable_hdmi="xrandr -d :0 --output HDMI-1 --auto"
alias display_list="xrandr -q"
alias display_mirror="xrandr --output HDMI-1 --same-as eDP-1"
