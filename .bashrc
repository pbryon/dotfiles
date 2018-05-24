function goto_repo {
    cd "$REPO/$1"
}

function complete_repo {
    local IFS=$'\n'
    tmp=( $(compgen -d -W "$(ls "$REPO")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

function current_git_branch {
    git branch 2> /dev/null | perl -ne 'print " [$_]" if s/^\*\s+// && chomp'
}

function dir_or_home {
     if [[ $PWD -ef $HOME ]]; then
        echo HOME@$(uname -n)
     elif [[ ${PWD##$REPO} != $PWD ]]; then
        echo repo ${PWD##$REPO} | sed -e 's/ \// /'
     else
        echo $PWD
     fi
}

CURDIR='$(dir_or_home)'
PS1="$CURDIR\$(current_git_branch)$ "
drive=/media/jos/Data
export REPO=$drive/experimental
export GITDIR=$drive/git
alias repo=goto_repo
alias gitdir="cd $GITDIR"
alias q=exit
alias ll="ls -la"
complete -F complete_repo repo
