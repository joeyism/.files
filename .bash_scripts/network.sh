#!/bin/bash
vpn(){
    sudo openvpn --config /etc/openvpn/client/$1
}
complete -W "$(ls /etc/openvpn/client/)" vpn
alias wifi_device_view_status="ip link show wlp3s0"
alias wifi_device_enable="ip link set wlp3s0 up"
alias wifi_iw_status="iw dev wlp3s0 link"
alias enable_dhcpcd="systemctl status dhcpcd"
alias scan_local_ssh="nmap 192.168.0.1/24 -p 22 --open"
ssh_remote_port(){
    read -p "Local Port: " local_port
    read -p "Remote Port: " remote_port
    ssh -L $local_port:localhost:$remote_port $@
}
