#!/bin/bash
update_pacman_key(){
    sudo pacman-key --populate archlinux
    sudo pacman-key --refresh-keys
    sudo /etc/pacman.d/gnupg /etc/pacman.d/gnupg-$(date +%F)
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
}
