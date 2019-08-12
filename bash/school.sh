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
CURRENT_PERIOD=1
local school_schedule="$REPO/kdg/P${CURRENT_PERIOD}.md" 
alias schedule="cat $school_schedule 2>/dev/null || echo \"No schedule yet for P${CURRENT_PERIOD}\" | head -n 11" 
