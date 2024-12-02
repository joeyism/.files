export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
PROMPT='%F{green}%*:%f%F{blue}%~%f%F{yellow}(${vcs_info_msg_0_})%f$ '
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line


export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll="ls -alG"
export EDITOR=vim
source ~/.bash_aliases
alias pip='noglob pip'
