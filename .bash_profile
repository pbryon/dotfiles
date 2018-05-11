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
     perl -MCwd -le 'my $dir = cwd(); print $dir =~ /$ENV{HOME}/ ? "HOME\@joske" : "$dir"'
}

CURDIR='$(dir_or_home)'
PS1="$CURDIR\$(current_git_branch)$ "
export REPO=/d/experimental
export GITDIR=/d/git
alias repo=goto_repo
alias gitdir="cd $GITDIR"
alias tree="ls -lR"
alias q=exit
alias ll="ls -la"
complete -F complete_repo repo
