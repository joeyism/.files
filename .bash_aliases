#!/bin/bash
alias :q=exit
alias port="sudo netstat -tulpn"
alias sa="source ~/.bash_aliases"
alias ea="vim ~/.bash_aliases"

alias pingg="ping google.com"

alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias terminal-browser="w3m http://www.google.com"
alias w3mvim="vim -c \":W3m https://www.google.com\""

alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias watchc="watch --color"
alias p="push"
alias gohere="cd $HERE"
alias ll="ls -lrth"
alias gcsp="gcloud config set project"
function _gcsp_(){
    COMPREPLY=($(compgen -W "$(gcloud projects list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcsp_ gcsp
alias cdll="cd $(ll | awk '{print $9}' | tail -n 1)"
alias realias="curl -X GET https://raw.githubusercontent.com/joeyism/.files/master/.bash_aliases > ~/.bash_aliases && source ~/.bash_aliases"
alias ha="head ~/.bash_aliases"

alias pipr="pip3 install --user -r requirements.txt"
alias piu="pip3 install --user"

alias got="go test -v -cover"
alias gor="go build && ./${PWD##*/}"

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

check_no_args(){
    if [ $# -eq 0 ]
        then
            echo "No arguments supplied"
            return 1
        else
            return 0
    fi
}

sample_use_check_no_args(){
    check_no_args $@
    if [ $? == 0 ]
    then
        echo $?
        echo "after"
    fi
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

remove_gcloud_app_by_id(){
    check_no_args $@
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
    check_no_args $@
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
    check_no_args $@
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
    check_no_args $@
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

grep_code(){
    grep -rnw . -e $1 --exclude-dir={node_modules,venv}
}

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
