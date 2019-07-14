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
