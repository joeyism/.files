#!/bin/bash
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias p="push"
alias grep_git="git rev-list --all | xargs git grep"
alias gdiff="git diff"
alias master="git checkout master && pull"
alias uncommit="git reset --soft HEAD^"
alias unadd="git reset"
alias rm_orig='find . | grep -E "(\.orig$)" | xargs rm -rf'
gitlist(){
    printf "You are in branch ${GREEN}$(git rev-parse --abbrev-ref HEAD)${NC}\n"
    printf "${CYAN_B}New Files${NC}\n"
    printf "${GREEN}$(git status --porcelain | awk '(match($1, "\?") || match($1, "A")){print " " $2}') ${NC}"
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
git-changeme(){
    read -p "Username: " username
    read -p "Email: " email
    git config --global user.name "$username"
    git config --global user.email "$email"
}
pushto(){
    if [ $# -eq 0 ]
        then
            read -p "Branch to push to: " tobranch
        else
            tobranch=$1
    fi
    git push origin $(git rev-parse --abbrev-ref HEAD):$tobranch ${@:2}
}
_pull(){
    COMPREPLY=($(compgen -W "$(git branch | tail -n +2)" -- "${COMP_WORDS[1]}"))
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
complete -F _pull pull
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
_get_git_branches(){
    git branch | cut -c 3-
}
checkout(){
    _check_no_args_quiet $1
    if [ $? == 1 ]; then
        select BRANCH_NAME in $(_get_git_branches);
        do  
            git checkout $BRANCH_NAME
            break
        done
    else
        if [ $1 == "new" ]; then
            _check_no_args_quiet $2
            if [ $? == 1 ]; then
                read -p "New Branch Name: " BRANCH_NAME
                git checkout -b $BRANCH_NAME
            else
                git checkout -b $2
            fi  
        else
            git checkout $1
        fi  
    fi  
}
complete -W "$(_get_git_branches)" checkout
merge(){
    _check_no_args_quiet $1
    if [ $? == 1 ]; then
        select BRANCH_NAME in $(_get_git_branches);
        do
            git merge $BRANCH_NAME
            break
        done
    else
        git merge $1
    fi
}
complete -W "$(_get_git_branches)" merge
pull-theirs(){
    git pull -s recursive -X theirs
}
