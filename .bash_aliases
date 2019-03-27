#!/bin/bash

##########################################################################
# COMMON
#
alias :q=exit
alias ll="ls -lrth"
alias watchc="watch --color"
alias whatismyip="curl ifconfig.me"
alias whereami='printf "$(curl -s ifconfig.co/city), $(curl -s ifconfig.co/country) {$(curl -s curl ifconfig.me)}"'
alias copy="xclip -selection clipboard"
alias wut="fortune | cowsay | lolcat"
alias grep_cheat="curl cheat.sh/grep"
alias gohere='cd $HERE'
alias here='HERE=$(pwd)'
alias s='status'
mkcd(){
    mkdir $@
    cd $@
}
status(){
  task
  gitlist
}
cheat(){
    curl cheat.sh/$1
}
grep_code(){
    grep -rnw . -e "$@" --exclude-dir={node_modules,venv}
}
grep_code_filename(){
    grep -rnwl . -e "$@" --exclude-dir={node_modules,venv}
}
findfile(){
    find . -path ./node_modules -prune -o -name $1 -print
}
_check_no_args(){
#     somefunction(){
#        _check_no_args $@
#        if [ $? != 0 ]
#        then
#            echo "Some help doc to show how to use somefunction"
#            return $?
#        fi
#        some_code_to_run_here
#     }

    if [ $# -eq 0 ]
        then
            echo "No arguments supplied"
            return 1
        else
            return 0
    fi
}
_check_no_args_quiet(){
    if [ $# -eq 0 ]
        then
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
# COLOURS
#
WHITE='\033[0;97m'
RED='\033[0;31m'
GREEN='\033[0;32m'
GREEN_B='\033[1;32m'
YELLOW='\033[0;33m'
YELLOW_B='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
CYAN_B='\033[1;36m'
NC='\033[0m' # no colour

##########################################################################
# CDA-ABLE
#
alias githome='git rev-parse --show-toplevel'
alias latest="ls -t1 |  head -n 1"
declare -A cda_locations=()
cda_total_keys=""
while IFS='' read -r line || [[ -n "$line" ]]; do     _key=$(echo $line| awk '{print $1}'); _value=$(echo $line | awk '{print $2}'); cda_locations[$_key]=$_value; cda_total_keys="$cda_total_keys $_key"; done < ~/.cda
if [ ! -f ~/.cda ]; then
  touch ~/.cda
fi
cda(){
    if [ -z "${BASH_ALIASES[$1]}" ]; then
      cd ${cda_locations[$1]}
    else
      cd $(printf "${BASH_ALIASES[$1]}" | bash)
    fi
}
complete -W "githome latest $cda_total_keys" cda

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
alias wifi_device_view_status="ip link show wlp3s0"
alias wifi_device_enable="ip link set wlp3s0 up"
alias wifi_iw_status="iw dev wlp3s0 link"
alias enable_dhcpcd="systemctl status dhcpcd"


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
# TASK-RELATED
#
reade () {
  tmpdir=$(date "+/tmp/%Y%m%d%H%M%S$$")
  mkdir "${tmpdir}"
  for ptag in "${predefinedtags[@]}" ; do
    touch "${tmpdir}"/"${ptag}"
  done
  readetags=$(cd "${tmpdir}" || printf "internal error" ; read -re usertags ; printf "%s" "${usertags}")
  rm -rf "${tmpdir}" 2>/dev/null >/dev/null
  eval "${1}"=\"\$\{readetags\}\"
}

_task_write_first(){
  sed -i "1i$TASK_ID" .task
}
_task_select_first(){
  sed -i "/$TASK_ID$/d" .task && awk -i inplace "BEGINFILE{print \"$TASK_ID\"}{print}" .task
}

task(){
    cda githome
    export TASK_ID=$(head -n 1 .task)

    _check_no_args_quiet $@
    if [ $? == 0 ]; then
        if [ $1 = "new" ]; then
            if [ -z "$2" ]; then
                read -p "Task: " task_id
                export TASK_ID=$task_id
            else
                export TASK_ID=$2 
            fi
            if [ ! -f .task ]; then
                echo $TASK_ID > .task
            elif grep -Fxq "$TASK_ID" .task; then
                echo "Task already exists!"
                echo "Switching to $TASK_ID now..."
                _task_select_first
            else
                echo $TASK_ID
                _task_write_first
            fi
            printf "Task is ${GREEN}${TASK_ID}${NC}\n"
        elif [ $1 = "select" ]; then
            if [ -z "$2" ]; then
                printf "${CYAN}Available tasks: ${NC}\n"
                select SELECT_TASK in $(cat .task);
                do
                    export TASK_ID=$SELECT_TASK
                    break
                done
            else
                export TASK_ID=$2
            fi
            _task_select_first
        elif [ $1 = "tmux" ]; then
            tmux new -s $TASK_ID
        elif [ $1 = "branch" ]; then
            git checkout master
            git pull origin master
            git checkout -b $TASK_ID || git checkout $TASK_ID
        elif [ $1 = "write" ]; then
            _task_write_first
        elif [ $1 = "rm" ]; then
            if [ -z "$2" ]; then
                printf "${CYAN}Available tasks: ${NC}\n"
                select SELECT_TASK in $(cat .task);
                do
                    export RM_TASK_ID=$SELECT_TASK
                    break
                done
            else
                export RM_TASK_ID=$2
            fi

            sed -i -e "/$RM_TASK_ID/d" .task
            if [ $RM_TASK_ID = $TASK_ID ]; then
                export TASK_ID=
            fi
            printf "Removed Task ${GREEN}${RM_TASK_ID}${NC}\n"
        elif [ $1 = "ls" ]; then
            printf "$(cat .task)\n"
        elif [ $1 == "purge" ]; then
            rm .task
        fi
    else
        printf "Task is ${GREEN}${TASK_ID}${NC}\n"
    fi
    cd -
}
_task()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "new select tmux branch write rm ls purge" -- ${cur}))
            ;;
        2)
            case ${prev} in
                select)
                    COMPREPLY=($(compgen -W "$(cat .task)" -- ${cur}))
                    ;;
                rm)
                    COMPREPLY=($(compgen -W "$(cat .task)" -- ${cur}))
                    ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}
complete -F _task task
alias t="task"
alias tt="task tmux"
alias tb="task branch"
alias tbt="task branch && task tmux"
alias ts="task select"
alias tsb="task select && task branch"
alias tsbt="task select && task branch && task tmux"
alias tnbt="task new && task branch && task tmux"
alias tls="task ls"
alias tn="task new"

##########################################################################
# GIT-RELATED
#
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias p="push"
alias grep_git="git rev-list --all | xargs git grep"
alias gdiff="git diff"
alias master="git checkout master && pull"
alias uncommit="git reset --soft HEAD^"
alias unadd="git reset"
gitlist(){
    printf "You are in branch ${GREEN}$(git rev-parse --abbrev-ref HEAD)${NC}\n"
    printf "${CYAN_B}New Files${NC}\n"
    printf "${GREEN}$(git status --porcelain | awk '(match($1, "?") || match($1, "A")){print " " $2}') ${NC}"
    printf "\n\n"
    printf "${CYAN_B}Modified Files${NC}\n"
    printf "${YELLOW}$(git status --porcelain | awk 'match($1, "M"){print " " $2}') ${NC}"
    printf "\n\n"
    printf "${CYAN_B}Deleted Files${NC}\n"
    printf "${RED}$(git status --porcelain | awk 'match($1, "D"){print " " $2}') ${NC}"
    printf "\n\n"
}
alias glist="gitlist"
git-new-mr(){
    xdg-open $(git-mr-url)
}
_push(){
    printf "${GREEN}Pushing...${NC}\n"
    git-remote-branch-exists
    exists=$?
    git push origin $(git rev-parse --abbrev-ref HEAD)
    if [ $exists == 1 ]; then
        echo "new MR"
        git-new-mr
    else
        echo "MR already exists"
    fi
}
push(){
    gitlist
    read -p "Commit files (all): " commit_files
    read -p "Commit message: " message
    if [ -z "$commit_files" ]
    then
        commit_files="-A"
    fi
    git add $commit_files
    printf "${GREEN}Committing...${NC}\n"
    git commit -m "$message"
    _push
}
pushall(){
    gitlist
    if [ $# -eq 0 ]
        then
            read -p "Commit message: " message
        else
            message=$@
    fi
    git add -A
    printf "${GREEN}Committing...${NC}\n"
    git commit -m "$message"
    _push
}
pull(){
    if [ $# -eq 0 ]
        then
            echo "git pull origin $(git rev-parse --abbrev-ref HEAD)"
            git pull origin $(git rev-parse --abbrev-ref HEAD)
        else
            echo "git pull origin $@"
            git pull origin $@
    fi
}
git-revert(){
    git checkout -- $@
}
_git-revert(){
    COMPREPLY=($(compgen -W "$(git status --porcelain | awk '{print $2}')" -- "${COMP_WORDS[1]}"))
}
complete -F _git-revert git-revert
git-source(){
    origin_url=$(git remote get-url origin)
    if [[ $origin_url == *"github"* ]]; then
        echo "github"
    elif [[ $origin_url == *"gitlab"* ]]; then
        echo "gitlab"
    else
        echo ""
    fi
}
git-mr-url(){
    gitsource=$(git-source)
    url=$(git remote get-url origin)
    nwo=$(echo "$url" | sed -E "s/^[^:]+:([^/]+\/[^.]+).git$/\1/")
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [ $gitsource == "github" ]; then
        echo "https://$gitsource.com/$nwo/pull/new/$branch"
    elif [ $gitsource == "gitlab" ]; then
        echo "https://gitlab.com/$nwo/merge_requests/new?merge_request%5Bsource_branch%5D=$branch"
    fi
}
git-remote-branch-exists(){
    origin_url=$(git remote get-url origin)
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ $(git ls-remote --heads $origin_url $branch) ]]; then
        return 0
    else
        return 1
    fi
}
git-merge-file(){
    select SELECT_BRANCH in $(git branch);
    do
        git checkout $SELECT_BRANCH $@
    done
}

gitvim(){
  vim $(git status --porcelain | awk '(match($1, "M") || match($1, "?")){print $2}')
}

##########################################################################
# PYTHON RELATED
#
alias pipr="pip install --user -r requirements.txt"
alias pip3r="pip3 install --user -r requirements.txt"
alias pipu="pip install --user"
alias pip3u="pip3 install --user"
alias ho="honcho -e .env run "
alias rm_pycache='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'
python_publish(){
    m2r README.md
    python setup.py sdist bdist_wheel
    twine check dist/*
    twine upload dist/*
}


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
function _gcil_name_(){
    COMPREPLY=($(compgen -W "$(gcloud compute instances list | awk '{print $1}' | tail -n +2)" -- "${COMP_WORDS[1]}"))
}
complete -F _gcil_name_ gcis
alias gciss="gcloud compute instances stop"
complete -F _gcil_name_ gciss
alias gcs="gcloud compute ssh"
complete -F _gcil_name_ gcs
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
#ec2-list(){
#    EC2_RAW=$(aws ec2 describe-instances)
#    for reservation in $(jq -r '.Reservations[] | @base64' <<< "$EC2_RAW"); do
#        reservation=$(base64 --decode <<< $reservation)
#        for tag in $(jq -r  '.Instances[0].Tags[] | @base64' <<< "$reservation" 2>/dev/null ); do
#          tag=$(base64 --decode <<< $tag)
#          if [ $(jq -r '.Key' <<< "$tag") == "Name" ]; then
#              printf $(jq -r '.Value' <<< "$tag")
#              printf "\t"
#              printf $(jq -r '.Instances[0].PrivateIpAddress' <<< "$reservation")
#              printf "\n"
#          fi
#        done
#    done
#}
ec2list(){
  aws ec2 describe-instances --output table   --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, PublicIpAddress, PrivateIpAddress]'  --filters "Name=tag-value,Values=*$1*" "Name=instance-state-name, Values=running"
}
alias s3_buckets="aws s3 ls"
s3_cat(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        printf "\ts3_cat [s3://bucket/folders]\n"
        return $?
    fi
    location=$1
    filenames=$(aws s3 ls $location | awk '{print $4}')
    for filename in $filenames; do
        echo "$(aws s3 cp ${location}${filename} -)"
    done
}
s3_filter(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        printf "\ts3_filter [bucket] [name-to-filter-by : optional]\n"
        return $?
    fi
    aws s3 ls --summarize --human-readable --recursive $1 | egrep "*$2*"
}

##########################################################################
# DOCKER Related
#
alias dps='docker ps'
alias dil='docker image ls'
alias drcs='docker rm $(docker ps -aq)' # docker rm containers
alias drcsf='docker rm -f $(docker ps -aq)' # docker rm containers
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

##########################################################################
# Audio Related
#

alias audio_master_unmute="amixer sset Master unmute"
alias audio_master_mute="amixer sset Master mute"

##########################################################################
# MISC Related
#
pearson_flights(){

  _check_no_args_quiet $@
  if [ $? == 1 ]; then
    printf "Please enter city name\n\n"
    printf "\tpearson_flights [city name]\n\n"
    return 1
  fi
  raw_data=$(curl -s 'https://www.torontopearson.com/FlightScheduleData/arr_gtaa_data_today.txt?_=1548271570315' -H 'cookie: GTAA_TAID=; EktGUID=75d1c646-d570-49f1-a709-3d9b48dbde90; _gcl_au=1.1.1787598826.1548269618; ecm=user_id=0&isMembershipUser=0&site_id=&username=&new_site=/&unique_id=0&site_preview=0&langvalue=0&DefaultLanguage=4105&NavLanguage=4105&LastValidLanguageID=4105&DefaultCurrency=840&SiteCurrency=840&ContType=&UserCulture=1033&dm=www.torontopearson.com&SiteLanguage=4105; AWSELB=2777B31F1EDD0B2866FBD8E69E9795B1136ED7BACC200227FC3AC034E5C0826C3CB29F6A0EB39357E9BA0F30EF5E56656E780D161AFB9B5CA124926C680DED8F4B5932DF5C' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 Vivaldi/2.2.1388.37' -H 'accept: application/json, text/javascript, */*; q=0.01' -H 'referer: https://www.torontopearson.com/en/flights/schedules/' -H 'authority: www.torontopearson.com' -H 'x-requested-with: XMLHttpRequest' --compressed)
  selected_city=$(echo "$1" | awk '{print toupper($0)}')
  printf "\nLast Updated: "
  echo $raw_data | jq -r '.["lastUpdated"]'
  echo ""
  for flight in $(jq -r '.aaData[] | @base64' <<< "$raw_data"); do
    flight=$(base64 --decode <<< $flight)
    if [[ "$(echo $flight | jq -r '.[2]')" =~ ${selected_city} ]]; then
      echo -e "${GREEN}$(echo $flight | jq -r '.[0]') ${WHITE}no $(echo $flight | jq -r '.[1]') from ${YELLOW}$(echo $flight | jq -r '.[2]')${NC}"
      echo -e "\tScheduled: $(echo $flight | jq -r '.[3]')"
      echo -e "\tExpected: $(echo $flight | jq -r '.[4]')"
      echo -e "\tStatus: $(echo $flight | jq -r '.[5]')"
      echo ""
    fi
  done
}
export -f pearson_flights
mount_android(){
    mkdir -p ~/AndroidMountPoint
    jmtpfs ~/AndroidMountPoint
}
mount_status(){
    sudo fdisk -l 
    mount -v | grep "^/" | awk '{print "\nPartition identifier: " $1  "\n Mountpoint: "  $3}'
}
mount_helper(){
  read -p "Partition identifier: " partition_identifier
  read -p "Mountpoint: " mountpoint
  sudo mount -o rw $partition_identifier $mountpoint
}
unmount(){
    mount -v | grep "^/" | awk '{print "\nPartition identifier: " $1  "\n Mountpoint: "  $3}'
    printf "\nPick a partition to unmount:\n"
    select partition_identifier in $(mount | grep "^/" | awk '{print $1}');
    do
        sudo umount $partition_identifier
        break
    done
}

get-env-from-envfile(){
  _check_no_args_quiet $1 && _check_no_args_quiet $2
  if [ $? == 1 ]; then
    printf "Please enter env file and var name\n\n"
    printf "\tget-env-from-envfile [env file] [variable wanted in env file]\n\n"
    return 1
  fi
  envfile=$1
  env_wanted=$2
  declare -A envars=()
  total_env_from_file=""
  while IFS='' read -r line || [[ -n "$line" ]]; do     
    if [ ! -z "$line" ]; then 
      _key=$(echo $line| cut -d= -f1); 
      _value=$(echo $line | cut -d= -f2); 
      if [ $_key == $env_wanted ]; then
        echo $_value
      fi
      envars[$_key]=$_value; 
      total_env_from_file="$total_env_from_file $_key"; 
    fi
  done < $envfile
}
