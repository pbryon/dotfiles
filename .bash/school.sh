read_config () {
    local file="$BASHRC_CONFIG"
    OLD_IFS="$IFS"
    IFS=$'\n'
    sep="$BASHRC_CONFIG_SEPARATOR"
    for line in `cat $file`; do
        if [[ "$line" =~ ^## ]]; then
            continue
        elif [[ "$line" =~ ^SCHOOL$sep[[:space:]]*(.+) ]]; then
            export SCHOOL=${BASH_REMATCH[1]};
        fi
    done
    IFS=${OLD_IFS}
}

read_config

if [ -z "$SCHOOL" ]; then
    return
fi

alias school="cd ${SCHOOL:-$PWD}"
alias todo="cat $REPO/kdg/TODO.md | grep -v x | head -n 20"
alias schedule="cat $REPO/kdg/P3.md | head -n 11"
