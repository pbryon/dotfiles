read_config () {
    local file="$HOME/.bashrc.conf"
    OLD_IFS="$IFS"
    IFS=$'\n'
    if [ ! -e "$file" ]; then
        echo No .bashrc.conf!
        return
    fi
    for line in `cat $file`; do
        if [[ "$line" =~ ^## ]]; then
            continue
        elif [[ "$line" =~ ^REPO:[[:space:]]*(.+) ]]; then
            export REPO=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^GIT:[[:space:]]*(.+) ]]; then
            export GITDIR=${BASH_REMATCH[1]};
        elif [[ "$line" =~ ^SCHOOL:[[:space:]]*(.+) ]]; then
            export SCHOOL=${BASH_REMATCH[1]};
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

current_git_branch () {
    local branch=$(git branch 2>/dev/null | grep '^*' | sed 's/^* //')
    if [ "$branch" ]; then
        status=$(git status | sed -n 's/.*\(behind\|ahead\).*/\1/p')
        local status_str=""
        if [ "$status" ]; then
            status_str="${blue}(${status})"
        elif [[ "$branch" =~ \((HEAD detached.*)\) ]]; then
            branch=${BASH_REMATCH[1]};
        fi

        echo -e "${bold}${status_str} ${green}[${branch}]${reset}"
    fi
}

dir_or_home () {
     local repo_relative=${PWD##$REPO}
     local home_relative=${PWD##$HOME}
     if [[ $repo_relative != $PWD ]]; then
        if [ $repo_relative ]; then
            echo -e $bold$yellow$repo_relative$reset | sed -e 's/\///'
        else
            echo -e ${bold}${yellow}REPO${reset}@$host
        fi
    elif [[ $home_relative != $PWD ]]; then
        echo -e ${bold}${yellow}HOME${reset}${home_relative}@$host
    else
        echo $PWD
     fi
}

git_log () {
    git log -n "${1:-10}"
}

git_pretty_log() {
    git log -n "${1:-200}" --pretty=format:"%h    %an    %s"
}

git_reflog() {
    git reflog | head -n "${1:-10}"
}

gitall () {
    for project in ./**; do
        if [ ! -d $project ]; then
            continue;
        fi
        cd $project
        local branch=$(git branch 2>/dev/null)
        if [ -d ".git" -a "$branch" ]; then
            echo
            echo "> repo '${project##./}'..."
            git "$@" 
        fi
        cd ..
    done
}

git_find="gf"
find_git_string () {
    if [ -z "$1" ]; then
        echo Usage:
        echo "$git_find [extension] <pattern>"
        echo
        echo With no extension, it will search all files.
        echo
        echo "If the pattern ends with a bang (!), it's case sensitive"
        echo
        return 1
    fi

    extension=$1
    pattern=$2
    if [ -z "$pattern" ]; then
        extension=""
        pattern=$1
    fi

    ignore_case="i"
    if [[ "$pattern" =~ !$ ]]; then
        # remove bang
        pattern=${pattern%!}
        ignore_case=""
    fi

    if [ -z "$extension" ]; then
        # grep -C = context
        git ls-files | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null
        return 0
    fi
    
    git ls-files | grep "$extension$" | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null
}
read_config

# NOTE: using the following is less likely to create line wrapping problems:
# \001 instead of \[
# \002 instead of \]
# \033 instead of \e
bold="\001\033[1m\002"
reset="\001\033[0m\002"
green="\001\033[38;5;46m\002"
yellow="\001\033[38;5;184m\002"
blue="\001\033[38;5;14m\002"
host="${blue}$(uname -n)$reset"
CURDIR='$(dir_or_home)'
PS1="$CURDIR\$(current_git_branch)$ "

# variables:
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim

# directories:
alias repo=goto_repo
alias gitdir="cd $GITDIR"
alias home="cd $HOME"
alias school="cd ${SCHOOL:-$PWD}"
alias q=exit
alias ll="ls -la"

# git-related:
alias changes="git status -vv | less -r"
alias findcss="find -type f -name *.css -o -name *.scss | xargs grep"
alias $git_find=find_git_string
alias gaa="git add --all"
alias gac="git add --all && git commit -v"
alias gb="git branch -avv"
alias gcp="git cherry-pick"
alias gl=git_log
alias glp=git_pretty_log
alias gs="git status"
alias gsf="git fetch && git status"
alias pullall="gitall pull"
alias refs=git_reflog
alias team="grep -E 'Yordi|Jelle|Pieter|Stefaan|Bart'"
complete -F complete_repo repo

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END
alias todo="cat $REPO/kdg/TODO.md | grep -v x | head -n 20"
alias schedule="cat $REPO/kdg/P3.md | head -n 11"
alias findcss="find -type f -name *.css -o -name *.scss | xargs grep"
