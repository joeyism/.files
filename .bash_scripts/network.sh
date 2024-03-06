#!/bin/bash
alias wifi_device_view_status="ip link show wlp3s0"
alias wifi_device_enable="ip link set wlp3s0 up"
alias wifi_iw_status="iw dev wlp3s0 link"
alias enable_dhcpcd="systemctl status dhcpcd"
alias scan_local_ssh="nmap 192.168.0.1/23 -p 22 --open"
ssh-remote-port(){
    if [ "$#" -lt 2 ]
    then
        echo "ssh-remote-port [machine name] [remote port] [local port] [args]"
        echo "example:"
        echo "    ssh-remote-port joey-machine-01 6006 6006"
        echo "currently:"
        echo "    ssh-remote-port $@ 6006 6006"
        read -p "Local Port: " local_port
        read -p "Remote Port: " remote_port
        ssh -L $local_port:localhost:$remote_port $@
        echo ssh -L $local_port:localhost:$remote_port $@
    else
        ssh -L $2:localhost:$3 $1 ${@:4}
        echo ssh -L $2:localhost:$3 $1 ${@:4}
    fi
}
