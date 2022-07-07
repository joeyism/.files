#!/bin/bash
alias gcsp="gcloud config set project"
function _gcsp_(){
    COMPREPLY=($(compgen -W "$(gcloud projects list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcsp_ gcsp
alias gcl="gcloud config list"
alias gcsp="gcloud config set project"
alias gcil="gcloud compute instances list"
alias gcis="gcloud compute instances start"
function _gcil_name_(){
    COMPREPLY=($(compgen -W "$(gcloud compute instances list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcil_name_ gcis
alias gciss="gcloud compute instances stop"
complete -F _gcil_name_ gciss
alias gcs="gcloud compute ssh"
complete -F _gcil_name_ gcs
function gcs-tunnel(){
    _check_no_args $@
    if [ $? != 0 ]
    then
        echo "gcs-tunnel [machine name] [remote port] [local port] [args]"
        echo "example:"
        echo "    gcs-tunnel joey-machine-01 6006 6006 --zone us-central1-a"
        return $?
    fi
    runcho gcloud compute ssh ${1} ${@:4} -- -NL ${2}:localhost:${3}
}
function gcissh(){
    gcis $@
    until gcs $@
    do
      sleep 0.1
    done
}
complete -F _gcil_name_ gcissh

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
