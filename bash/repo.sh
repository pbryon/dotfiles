#!/bin/bash
script=$BASH_SOURCE
export MAIN_BRANCH=master
export DEV_BRANCH=development
export STAGING_BRANCH=staging

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
        elif [[ "$line" =~ ^TFS$sep[[:space:]]*(.+) ]]; then
            export TFS=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^WORK_DIR$sep[[:space:]]*(.+) ]]; then
            export WORK_DIR=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^FIND_FILE_IGNORE$sep[[:space:]]*(.+) ]]; then
            export FIND_FILE_IGNORE=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^MAIN_BRANCH$sep[[:space:]]*(.*) ]]; then
            export MAIN_BRANCH=${BASH_REMATCH[1]};
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

goto_work () {
    cd "$WORK_DIR/$1"
    if [ "$2" ]; then
        echo "Running git $2..."
        git $2
    fi
}

goto_tfs () {
    cd "$TFS/$1"
}

complete_repo () {
    local IFS=$'\n'
    local tmp=( $(compgen -d -W "$(ls "$REPO")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

complete_work () {
    local IFS=$'\n'
    local tmp=( $(compgen -d -W "$(ls "$WORK_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

read_config
alias repo=goto_repo
alias work=goto_work
alias tfs=goto_tfs
complete -F complete_repo repo
complete -F complete_work work
