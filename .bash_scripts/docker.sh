#!/bin/bash
alias dps='docker ps'
alias dil='docker image ls'
alias drcs='docker rm $(docker ps -aq)' # docker rm containers
alias drcsf='docker rm -f $(docker ps -aq)' # docker rm containers
alias dscs='docker stop $(docker ps -q)' #docker stop containers
alias dris='docker rmi $(docker images -q)' #docker rm images
drun(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        echo "  drun [name of image]"
        echo "Ex."
        echo "  drun ubuntu:latest"
        return $?
    fi
    docker run -it -d $@ ;
};
_drun_(){ COMPREPLY=($(compgen -W "$(docker image ls --format '{{.Repository}}')" -- "${COMP_WORDS[1]}")) ; };
complete -F _drun_ drun
drunbash(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        echo "drunbash [name of image]"
        echo "Ex."
        echo "  drunbash ubuntu:latest"
        return $?
    fi
    echo docker run -it ${@:2} --entrypoint bash $1
    docker run -it ${@:2} --entrypoint bash $1
};
complete -F _drun_ drunbash
dbash(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        echo "dbash [name of active container]"
        echo "Ex."
        echo "  dbash competent_hertz"
        return $?
    fi
    docker exec -it $1 bash ;
};
_dbash_(){ COMPREPLY=($(compgen -W "$(docker ps --format '{{.Names}}')" -- "${COMP_WORDS[1]}")) ;};
complete -F _dbash_ dbash
docker-latest-image(){
    docker image ls | head -n 2 | tail -n -1 | awk '{print $3}'
}
docker-test-dockerignore(){
    rsync -avn . /dev/shm --exclude-from .dockerignore
}
