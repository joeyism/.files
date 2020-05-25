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
