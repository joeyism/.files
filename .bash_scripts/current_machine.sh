#!/bin/bash
alias pingg="ping google.com"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias port="sudo netstat -tulpn"

kssh(){
    kitty +kitty ssh $@
}

proc_origin(){
    sudo readlink -f /proc/$1/exe
}

port_exec(){
    port | grep $1 | awk '{print $7}' | sed -e 's/.*\///g'
}

port_proc(){
    port | grep $1 | awk '{print $7}' | sed -e 's/\/.*//g'
}

port_origin(){
    proc_origin $(port_proc $1)
}

pwdf(){
    echo $(pwd)/$1
}

_gen_pw(){
  date +%s | sha256sum | base64 | head -c 32 ; echo
}

pw(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        read -p "Name of the service: " service
        new_pw=$(_gen_pw)
        echo $new_pw > ~/.ssh/pw/$service
        echo $new_pw | xclip -selection clipboard
        return
    fi
    if [ $1 == list ]
    then
        ls ~/.ssh/pw
    else
        cat ~/.ssh/pw/$1 | tr -d '\n' | xclip -selection clipboard
    fi

}
complete -W "$(ls ~/.ssh/pw)" pw
