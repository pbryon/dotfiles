#!/bin/bash
script=$BASH_SOURCE
read_config () {
    local file="$BASHRC_CONFIG"
    OLD_IFS="$IFS"
    IFS=$'\n'
    sep="$BASHRC_CONFIG_SEPARATOR"
    if [ ! -e "$file" ]; then
        echo $script: no .bashrc.conf!
        return
    fi
    for line in `cat $file`; do
        if [[ "$line" =~ ^## ]]; then
            continue
        elif [[ "$line" =~ ^REPO$sep[[:space:]]*(.+) ]]; then
            export REPO=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^GIT$sep[[:space:]]*(.+) ]]; then
            export GITDIR=${BASH_REMATCH[1]};
        fi
    done
    IFS=${OLD_IFS}
}

goto_repo () {
    cd "$REPO/$1"
    if [ "$2" ]; then
        echo "Running git $2..."
        git $2
    fi
}

complete_repo () {
    local IFS=$'\n'
    local tmp=( $(compgen -d -W "$(ls "$REPO")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

read_config
alias repo=goto_repo
alias gitdir="cd $GITDIR"
complete -F complete_repo repo
