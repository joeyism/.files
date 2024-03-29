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
        if [ -z $2 ]; then
            read -p "Alias: " alias
        else
            alias=$2
        fi
        echo "$alias $(pwd)" >> ~/.cda
        source ~/.bash_scripts/cda.sh
        echo "Created $alias $(pwd)"
    elif [ -z "$1" ]; then
      cat ~/.cda
    else
      cd ${cda_locations[$1]}
    fi
    
    if [ -d "venv" ]; then
      venv
    fi

    if [ -f ".bashlc" ]; then
        source .bashlc
    fi
}
complete -W "githome latest $cda_total_keys" cda
