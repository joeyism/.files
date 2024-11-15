# Useful tools

# Passes in a url and downloads it locally
download(){
    url=$1
    _check_no_args_quiet
    if [ $? != 0 ]
    then
        read -p "url: " url
    fi
    filename=$(echo $url | tr "?" "\n" | head -n 1 | tr "/" "\n" | tail -n 1)
    wget "$url" -O $filename
}

json-to-env(){
    _check_no_args_quiet
    if [ $? != 0 ]
    then
        echo "json-to-env [filename]"
        echo "Example:"
        echo -e "\tjson-to-env .env.json > .env\n"
    else
        cat $1 | jq -r 'to_entries | .[] | "\(.key)=\(.value)"'
    fi
}
