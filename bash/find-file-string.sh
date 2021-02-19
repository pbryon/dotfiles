file_find="ff"
file_name="fn"
not_like="not"
not_blank="not_empty"

read_config() {
    local file="$BASHRC_CONFIG"
    OLD_IFS="$IFS"
    IFS=$'\n'
    sep="$BASHRC_CONFIG_SEPARATOR"
    if [ ! -e "$file" ]; then
        echo $script: no .bashrc.conf!
        return
    fi
    for line in `cat $file`; do
        if [[ "$line" =~ ^## ]]; then
            continue
        elif [[ "$line" =~ ^FIND_FILE_IGNORE$sep[[:space:]]*(.+) ]]; then
            export FIND_FILE_IGNORE=${BASH_REMATCH[1]};
        fi
    done
    IFS=${OLD_IFS}
}

not () {
    if [ -z "$1" ]; then
        echo Excludes the given pattern and filters out empty lines
        echo
        echo Usage:
        echo "$not_like <pattern>"
        echo
        return 1
    fi

    pattern=$1
    grep -vi $pattern | not_empty
}

not_empty () {
    grep_with_context_empty="\-\-"
    grep -v $grep_with_context_empty | grep -e "\S"
}

find_file_string () {
    if [ -z "$1" ]; then
        echo Usage:
        echo "$file_find [extension] <pattern>"
        echo
        echo With no extension, it will search all files.
        echo
        echo "If the extension ends with a bang (!), it is excluded instead"
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

    binary_file="Binary file"
    remove_current_dir="s|${PWD}/||g"

    if [ -z "$extension" ]; then
        # grep -C = context
        find . -type f -print0 \
        | grep --null-data -v -E $FIND_FILE_IGNORE \
        | xargs -0 grep -"$ignore_case"n "$pattern" -C 2 --color=always 2>/dev/null \
        | grep -v "$binary_file" \
        | sed -e "$remove_current_dir"
 
        return 0
    fi
   
    exclude=""
    if [[ "$extension" =~ !$ ]]; then
        # remove bang
        extension=${extension%!}
        find . -type f -print0 \
        | grep --null-data -v -E $FIND_FILE_IGNORE \
        | grep --null-data -v "$extension$" \
        | xargs -0 grep -"$ignore_case"n "$pattern" -C 2 --color=always 2>/dev/null \
        | grep -v "$binary_file" \
        | sed -e "$remove_current_dir"
    else
        find . -type f -print0 \
        | grep --null-data -v -E $FIND_FILE_IGNORE \
        | grep --null-data "$extension$" \
        | xargs -0 grep -"$ignore_case"n "$pattern" -C 2 --color=always 2>/dev/null \
        | grep -v "$binary_file" \
        | sed -e "$remove_current_dir"

    fi
}

read_config
alias $file_find=find_file_string
alias $file_name='find . -type f -name '
alias $not_like=not
alias $not_blank=not_empty
