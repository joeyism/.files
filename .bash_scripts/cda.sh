#!/bin/bash
alias githome='git rev-parse --show-toplevel'
alias latest="ls -t1 |  head -n 1"
declare -A cda_locations=()
cda_total_keys=""
while IFS='' read -r line || [[ -n "$line" ]]; do     _key=$(echo $line| awk '{print $1}'); _value=$(echo $line | awk '{print $2}'); cda_locations[$_key]=$_value; cda_total_keys="$cda_total_keys $_key"; done < ~/.cda
if [ ! -f ~/.cda ]; then
  touch ~/.cda
fi
cda(){
    if [ -d "venv" ]; then
      deactivate
    fi

    if [ "$1" == "new" ]; then
        echo "$2 $(pwd)" >> ~/.cda
        source ~/.bash_scripts/cda.sh
    elif [ -z "${BASH_ALIASES[$1]}" ]; then
      cd ${cda_locations[$1]}
    else
      cd $(printf "${BASH_ALIASES[$1]}" | bash)
    fi
    
    if [ -d "venv" ]; then
      venv
    fi

    if [ -f ".bashlc" ]; then
        source .bashlc
    fi
}
complete -W "githome latest $cda_total_keys" cda
