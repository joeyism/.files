#!/bin/bash
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
docker-latest-image(){
    docker image ls | head -n 2 | tail -n -1 | awk '{print $3}'
}
