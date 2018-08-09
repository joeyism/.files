#!/bin/bash
alias :q=exit
alias pipr="pip3 install --user -r requirements.txt"
alias port="sudo netstat -tulpn"
alias sa="source ~/.bash_aliases"
alias ea="vim ~/.bash_aliases"
alias gcil="google compute instances list"
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias watchc="watch --color"
alias gail="gcloud app instances list"
alias gavl="gcloud app versions list"
alias p="push"
alias got="go test -v -cover"
alias gor="go build && ./${PWD##*/}"
alias gohere="cd $HERE"
alias ll="ls -lrth"
alias gcsp="gcloud config set project"
alias cdll="cd $(ll | awk '{print $9}' | tail -n 1)"


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
    grep -rnw . -e $1 --exclude-dir=node_modules
}

ecslog_once(){
    ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}

ecslog(){
    watch --color ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}
