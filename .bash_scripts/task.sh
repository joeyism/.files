#!/bin/bash
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
  sed -i "/$TASK_ID$/d" .task
  _task_write_first
}

task(){
    cda githome
    export TASK_ID=$(head -n 1 .task)
    export MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

    _check_no_args_quiet $@
    if [ $? == 0 ]; then
        if [ $1 = "new" ]; then
            if [ -z "$2" ]; then
                read -p "Task: " task_id
                export TASK_ID=$task_id
            else
                export TASK_ID=$2 
            fi
            if [[ ! -f .task || ! -s .task ]]; then
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
            tmux has-session -t $TASK_ID 2>/dev/null
            if [ $? != 0 ]; then
                tmux new -s $TASK_ID
            else
                tmux attach-session -t $TASK_ID
            fi
        elif [ $1 = "branch" ]; then
            git checkout $MAIN_BRANCH
            git pull origin $MAIN_BRANCH
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
alias tnb="task new && task branch"
alias tnbt="task new && task branch && task tmux"
alias tls="task ls"
alias tn="task new"
