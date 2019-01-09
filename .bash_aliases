#!/bin/bash

##########################################################################
# COMMON
#
alias :q=exit
alias ll="ls -lrth"
alias watchc="watch --color"
alias whatismyip="curl ifconfig.me"
alias whereami='printf "$(curl -s ifconfig.co/city), $(curl -s ifconfig.co/country) {$(curl -s curl ifconfig.me)}"'
cheat(){
  curl cheat.sh/$1
}
alias grep_cheat="curl cheat.sh/grep"
gohere(){
    cd $HERE
}
grep_code(){
    grep -rnw . -e $1 --exclude-dir={node_modules,venv}
}
findfile(){
    find . -path ./node_modules -prune -o -name $1 -print
}
_check_no_args(){
#   sample_use_check_no_args(){
#       _check_no_args $@
#       if [ $? == 0 ]
#       then
#           echo $?
#           echo "after"
#       fi
#   }
    if [ $# -eq 0 ]
        then
            echo "No arguments supplied"
            return 1
        else
            return 0
    fi
}
helpa(){ # help alias
    TOPRINT=false
    INPUT="${1^^}"
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [[ $line == *$INPUT* ]]; then
            TOPRINT=true
        elif [[ $line == "##########################################################################" ]]; then
            TOPRINT=false
        fi

        if $TOPRINT; then
            printf "$line\n"
        fi
    done < ~/.bash_aliases
}
senv(){
    set -a
    source $1
    set +a
}

##########################################################################
# CDA-ABLE
#
alias githome='git rev-parse --show-toplevel'
alias latest="ls -t1 |  head -n 1"

cda(){
    cd $(printf "${BASH_ALIASES[$1]}" | bash)
}
complete -W "githome latest" cda

##########################################################################
# BASH_ALIASES RELATED
#
alias sa="source ~/.bash_aliases"
alias ea="vim ~/.bash_aliases"
alias realias="curl -X GET https://raw.githubusercontent.com/joeyism/.files/master/.bash_aliases > ~/.bash_aliases && source ~/.bash_aliases"
alias diffa="vimdiff <(curl -sL https://raw.githubusercontent.com/joeyism/.files/master/.bash_aliases) ~/.bash_aliases"

##########################################################################
# CHECK STATUS OF MACHINE
#
alias pingg="ping google.com"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias port="sudo netstat -tulpn"
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

here(){
    HERE=$(pwd)
}

pw(){
    if [ $1 == list ]
    then
        ls ~/.ssh/pw
    else
        cat ~/.ssh/pw/$1 | tr -d '\n' | xclip -selection clipboard
    fi

}
complete -W "$(ls ~/.ssh/pw)" pw

##########################################################################
# NETWORK
#

vpn(){
    sudo openvpn --config /etc/openvpn/client/$1
}
complete -W "$(ls /etc/openvpn/client/)" vpn


##########################################################################
# DISPLAY
#
alias display_laptop_brightness="xrandr --output eDP-1 --brightness"
alias display_hdmi_brightness="xrandr --output HDMI-1 --brightness"
alias display_enable_hdmi="xrandr -d :0 --output HDMI-1 --auto"
alias display_list="xrandr -q"
alias display_mirror="xrandr --output HDMI-1 --same-as eDP-1"


##########################################################################
# TERMINAL BROWSING
#
alias terminal-browser="w3m http://www.google.com"
alias w3mvim="vim -c \":W3m https://www.google.com\""

##########################################################################
# GIT-RELATED
#
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias p="push"
alias grep_git="git rev-list --all | xargs git grep"

##########################################################################
# PYTHON RELATED
#
alias pipr="pip install --user -r requirements.txt"
alias pip3r="pip3 install --user -r requirements.txt"
alias pipu="pip install --user"
alias pip3u="pip3 install --user"
alias ho="honcho -e .env run "


##########################################################################
# GOLANG RELATED
#
alias got="go test -v -cover"
alias gor="go build && ./${PWD##*/}"

##########################################################################
# GCP RELATED
#
alias gcsp="gcloud config set project"
function _gcsp_(){
    COMPREPLY=($(compgen -W "$(gcloud projects list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcsp_ gcsp
alias gcl="gcloud config list"
alias gcsp="gcloud config set project"
alias gcil="gcloud compute instances list"
alias gcis="gcloud compute instances start"
function _gcis_(){
    COMPREPLY=($(compgen -W "$(gcloud compute instances list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcis_ gcis
alias gciss="gcloud compute instances stop"
function _gciss_(){
    COMPREPLY=($(compgen -W "$(gcloud compute instances list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gciss_ gciss
alias gcs="gcloud compute ssh"
function _gcs_(){
    COMPREPLY=($(compgen -W "$(gcloud compute instances list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcs_ gcs

function _gcscp_(){
    list="$(gcloud compute instances list | awk '{print $1}' | tail -n +2)"
    list="$list $(ls)"
    COMPREPLY=($(compgen -W "$list" -- "${COMP_WORDS[1]}"))
}
alias gcscp="gcloud compute scp"
complete -F _gcscp_ gcscp

alias gail="gcloud app instances list"
alias gavl="gcloud app versions list"

remove_gcloud_app_by_id(){
    _check_no_args $@
    if [ $? != 0 ]
    then
        return $?
    fi

    gcloud app instances list | sed 1d | \
        while read i
        do
            if [ $1 == $(awk '{print $3}' <<< $i) ]
            then
                echo "gcloud app instances delete $(awk '{print $3}' <<< $i) --service=$(awk '{print $1}' <<< $i) --version=$(awk '{print $2}' <<< $i) --quiet"
                gcloud app instances delete $(awk '{print $3}' <<< $i) --service=$(awk '{print $1}' <<< $i) --version=$(awk '{print $2}' <<< $i) --quiet
            fi
        done
}

remove_gcloud_app_version_by_status(){
    _check_no_args $@
    if [ $? != 0 ]
    then
        return $?
    fi

    gavl | sed 1d | \
        while read i
        do
            if [ $1 == $(awk '{print $5}' <<< $i) ]
            then
                echo "gcloud app versions delete $(awk '{print $2}' <<< $i) --quiet"
                gcloud app versions delete $(awk '{print $2}' <<< $i) --quiet
            fi
        done
}

remove_gcloud_app_version_by_service(){
    _check_no_args $@
    if [ $? != 0 ]
    then
        return $?
    fi

    gavl | sed 1d | \
        while read i
        do
            if [ $1 == $(awk '{print $1}' <<< $i) ]
            then
                echo "gcloud app versions delete $(awk '{print $2}' <<< $i) --quiet"
                gcloud app versions delete $(awk '{print $2}' <<< $i) --quiet
            fi
        done
}

remove_gcloud_app_by_service(){
    _check_no_args $@
    if [ $? != 0 ]
    then
        return $?
    fi

    gcloud app instances list | sed 1d | \
        while read i
        do
            if [ $1 == $(awk '{print $1}' <<< $i) ]
            then
                echo "gcloud app instances delete $(awk '{print $3}' <<< $i) --service=$(awk '{print $1}' <<< $i) --version=$(awk '{print $2}' <<< $i) --quiet"
                gcloud app instances delete $(awk '{print $3}' <<< $i) --service=$(awk '{print $1}' <<< $i) --version=$(awk '{print $2}' <<< $i) --quiet
            fi
        done
}

##########################################################################
# AWS RELATED
#
ecslog_once(){
    ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}

ecslog(){
    watch --color ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}

stream-kinesis(){
    PROFILE=default
    RUN=true

    for i in "$@"
    do
    case $i in
        -p=*|--profile=*)
        PROFILE="${i#*=}"
        shift # past argument=value
        ;;
        -s=*|--streamname=*)
        STREAMNAME="${i#*=}"
        shift # past argument=value
        ;;
        -h*|--help*)
        echo "HELP"
        RUN=false
        ;;
        *)
              # unknown option
        ;;
    esac
    done

    if $RUN ; then
        SHARDS=$(aws kinesis list-shards --stream-name $STREAMNAME --profile $PROFILE)
        SHARDID=$(jq -r  '.Shards[0].ShardId' <<< "$SHARDS")
        SHARD_ITERATOR_JSON=$(aws kinesis get-shard-iterator --stream-name $STREAMNAME --shard-id $SHARDID --shard-iterator-type LATEST --profile $PROFILE)
        SHARD_ITERATOR_VAL=$(jq -r  '.ShardIterator' <<< "$SHARD_ITERATOR_JSON")
        ITERATOR_VAL=$(aws kinesis get-records --shard-iterator $SHARD_ITERATOR_VAL --profile $PROFILE)
        for row in $(jq -r  '.Records[] | @base64' <<< "$ITERATOR_VAL" ); do
            SHARD_DATA_JSON=$(base64 --decode <<< $row)
            SHARD_DATA_RAW=$(jq -r  '.Data' <<< "$SHARD_DATA_JSON")
            echo $(base64 --decode <<< $SHARD_DATA_RAW) | jq -r ${1}
        done

    fi

}
ec2-list(){
    EC2_RAW=$(aws ec2 describe-instances)
    for reservation in $(jq -r '.Reservations[] | @base64' <<< "$EC2_RAW"); do
        reservation=$(base64 --decode <<< $reservation)
        for tag in $(jq -r  '.Instances[0].Tags[] | @base64' <<< "$reservation" 2>/dev/null ); do
          tag=$(base64 --decode <<< $tag)
          if [ $(jq -r '.Key' <<< "$tag") == "Name" ]; then
              printf $(jq -r '.Value' <<< "$tag")
              printf "\t"
              printf $(jq -r '.Instances[0].PrivateIpAddress' <<< "$reservation")
              printf "\n"
          fi
        done
    done
}

##########################################################################
# DOCKER Related
#
alias dps='docker ps'
alias dil='docker image ls'
alias drcs='docker rm $(docker ps -aq)' # docker rm containers
alias dscs='docker stop $(docker ps -q)' #docker stop containers
alias dris='docker rmi $(docker images -q)' #docker rm images
drun(){ docker run -it -d $@ ;};
_drun_(){ COMPREPLY=($(compgen -W "$(docker image ls --format '{{.Repository}}')" -- "${COMP_WORDS[1]}")) ; };
complete -F _drun_ drun
dbash(){ docker exec -it $1 bash ;};
_dbash_(){ COMPREPLY=($(compgen -W "$(docker ps --format '{{.Names}}')" -- "${COMP_WORDS[1]}")) ;};
complete -F _dbash_ dbash

##########################################################################
# ARCH Related
#
update_pacman_key(){
    sudo pacman-key --populate archlinux
    sudo pacman-key --refresh-keys
    sudo /etc/pacman.d/gnupg /etc/pacman.d/gnupg-$(date +%F)
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
}
