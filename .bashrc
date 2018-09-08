read_config () {
    file="$HOME/.bashrc.conf"
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
    tmp=( $(compgen -d -W "$(ls "$REPO")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
    COMPREPLY=( "${tmp[@]// /\ }" )
}

current_git_branch () {
    branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
    if [ $branch ]; then
        status=$(git status | sed -n 's/.*\(behind\|ahead\).*/\1/p')
        status_str=""
        if [ $status ]; then
            status_str="${blue}(${status})"
        fi
        echo -e "${bold}${status_str} ${green}[${branch}]${reset}"
    fi
}

dir_or_home () {
     repo_relative=${PWD##$REPO}
     home_relative=${PWD##$HOME}
     if [[ $home_relative != $PWD ]]; then
        echo -e ${bold}${yellow}HOME${reset}${home_relative}@$host
     elif [[ $repo_relative != $PWD ]]; then
        if [ $repo_relative ]; then
            echo -e $bold$yellow$repo_relative$reset | sed -e 's/\///'
        else
            echo -e ${bold}${yellow}REPO${reset}@$host
        fi
    else
        echo $PWD
     fi
}

read_config
bold="\e[1m"
reset="\e[0m"
green="\e[38;5;46m"
yellow="\e[38;5;184m"
blue="\e[38;5;14m"
host="${blue}$(uname -n)$reset"
CURDIR='$(dir_or_home)'
PS1="\[$CURDIR\$(current_git_branch)\]$ "
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim
alias repo=goto_repo
alias gitdir="cd $GITDIR"
alias home="cd $HOME"
alias data="cd $drive"
alias q=exit
alias ll="ls -la"
alias gaa="git add --all"
alias gac="git add --all && git commit"
alias gs="git status"
alias gsf="git fetch && git status"
complete -F complete_repo repo
if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END

