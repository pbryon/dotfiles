load_import_files () {
    path="$(dirname $BASH_SOURCE)/bash"
    for file in $(ls $path); do
        . $path/$file
    done
}

# used by repo.sh and school.sh
export BASHRC_CONFIG="$HOME/.bashrc.conf"
export BASHRC_CONFIG_SEPARATOR=":"

load_import_files

# variables:
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
export EDITOR=vim
alias pip="python -m pip"

# directories:
alias home="cd $HOME"

alias q=exit
alias ll="ls -la"

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END
cd $REPO

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
