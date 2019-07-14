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

# used by repo.sh and school.sh
export BASHRC_CONFIG="$HOME/.bashrc.conf"
export BASHRC_CONFIG_SEPARATOR=":"
import_files=(ps1 repo git-log git-all find-git-string school)
load_import_files

# variables:
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim

# directories:
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

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END

