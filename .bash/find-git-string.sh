git_find="gf"
find_git_string () {
    if [ -z "$1" ]; then
        echo Usage:
        echo "$git_find [extension] <pattern>"
        echo
        echo With no extension, it will search all files.
        echo
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

    if [ -z "$extension" ]; then
        # grep -C = context
        git ls-files | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null
        return 0
    fi
    
    git ls-files | grep "$extension$" | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null
}

alias $git_find=find_git_string