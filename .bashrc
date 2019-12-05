load_import_files () {
    for file in ${import_files[@]}; do
        path="$(dirname $BASH_SOURCE)/bash"
        file=$file.sh
        if [ -f "$path/$file" ]; then
            . $path/$file
        else
            echo "-> missing source: $path/$file"
        fi
    done
}

# used by repo.sh and school.sh
export BASHRC_CONFIG="$HOME/.bashrc.conf"
export BASHRC_CONFIG_SEPARATOR=":"
import_files=(ps1 repo git-aliases git-log git-all find-git-string git-is-merged git-reset-to school)
load_import_files

# variables:
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim

# directories:
alias home="cd $HOME"

alias q=exit
alias ll="ls -la"

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END

