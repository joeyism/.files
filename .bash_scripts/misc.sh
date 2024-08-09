#!/bin/bash
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
_get-env-from-envfile(){ 
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "$(ls -A)" -- ${cur}))
            ;;
        2)
            COMPREPLY=($(compgen -W "$(cat $prev | awk '{print $1}')" -- ${cur}))
            ;;
        *)
            COMPREPLY=()
            ;;
    esac

}
complete -F _get-env-from-envfile get-env-from-envfile

ngrok-url(){
  curl --silent http://127.0.0.1:4040/api/tunnels | jq -r ".tunnels[0].public_url"
}
mp4togif(){
  inputname=$1
  outputgif="${inputname::-4}.gif"
  ffmpeg -i $inputname -f gif $outputgif
}
alias gif="sxiv -a"
json-join(){
    INPUT=$@;
    _check_no_args_quiet $INPUT
    if [ $? == 1 ]; then
        printf "Joins JSON arrays into one output\n"
        printf "Usage:\n"
        printf "\tjson-join file1.json file2.json ...\n"
        printf "\tjson-join *.json\n"
        printf "\tjson-join *.json > output.json\n\n"
        return 1
    fi
    JQ_STR='';
    TOTAL_NUM_FILES=$(($(ls $INPUT | wc -l)-1))
    i=0;
    echo "["
    for file in $INPUT; do
        if [ $i -eq $TOTAL_NUM_FILES ]; then
            echo "$(jq -r -s '.[]' $file | tail -n +2 | head -n -1)"
        else
            echo "$(jq -r -s '.[]' $file | tail -n +2 | head -n -1),"
        fi
        ((i++))
    done
    echo "]"
}
