#!/bin/bash
alias display_laptop_brightness="xrandr --output eDP-1 --brightness"
alias display_hdmi_brightness="xrandr --output HDMI-1 --brightness"
alias display_dp_brightness="xrandr --output DP-1 --brightness"
alias display_enable_hdmi="xrandr -d :0 --output HDMI-1 --auto"
alias display_enable_dp="xrandr -d :0 --output DP-1 --auto"
alias display_list="xrandr -q"
alias display_mirror_hdmi="xrandr --output HDMI-1 --same-as eDP-1"
alias display_mirror_dp="xrandr --output DP-1 --same-as eDP-1"
