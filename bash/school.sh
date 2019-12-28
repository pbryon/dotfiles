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

print_schedule() {
    local school_schedule="$REPO/kdg/SCHEDULE.md"
    local no_schedule="No schedule found!"
    local schedule_header="# Schedule"
    local markdown_h1="# "
    local then_print="{/.*/p}"
    local delete_last_line='$d'
    sed --quiet "/$schedule_header/,/^$markdown_h1/$then_print" $school_schedule 2>/dev/null | sed $delete_last_line || echo $no_schedule
    echo
}

alias school="cd ${SCHOOL:-$PWD}"
alias todo="cat $REPO/kdg/TODO.md | grep -v x | head -n 20"
alias schedule=print_schedule  
