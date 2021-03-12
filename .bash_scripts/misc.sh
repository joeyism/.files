#!/bin/bash
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
