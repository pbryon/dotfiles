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

load_import_files () {
    for file in ${import_files[@]}; do
        path=.bash
        file=$file.sh
        if [ -f "$path/$file" ]; then
            . $path/$file
            echo "-> loaded $file"
        else
            echo "-> missing source: $path/$file"
        fi
    done

}

read_config
import_files=(ps1 repo git-log git-all find-git-string school)
load_import_files

# variables:
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim

# directories:
alias gitdir="cd $GITDIR"
alias home="cd $HOME"

alias q=exit
alias ll="ls -la"

# git-related:
alias changes="git status -vv | less -r"
alias gaa="git add --all"
alias gac="git add --all && git commit -v"
alias gb="git branch -avv"
alias gcp="git cherry-pick"
alias gs="git status"
alias gsf="git fetch && git status"

alias team="grep -E 'Yordi|Jelle|Pieter|Stefaan|Bart'"

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END

