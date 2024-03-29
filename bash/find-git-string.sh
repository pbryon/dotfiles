git_find="gf"
git_find_conflict="gfc"

find_git_string () {
    default_context="2"
    if [ -z "$1" ]; then
        echo Usage:
        echo "$git_find [extension] <pattern> [<context>]"
        echo
        echo With no extension, it will search all files.
        echo
        echo "If the extension ends with a bang (!), it is excluded instead"
        echo "If the pattern ends with a bang (!), it's case sensitive"
        echo
        echo The default context is $default_context lines before/after a match
        echo
        return 1
    fi

    arg_count=$#
    extension=$1
    pattern=$2
    context=${3:-$default_context}

    if [ $arg_count = 1 ]; then
        extension=""
        pattern=$1
        context=$default_context
    elif [ $arg_count = 2 ]; then
        if [[ "$2" =~ ^[0-9]+$ ]]; then      
            extension=""
            pattern=$1
            context=${2:-$default_context}
        else
            extension=$1
            pattern=$2
            context=$default_context
        fi
    fi

    ignore_case="i"
    if [[ "$pattern" =~ !$ ]]; then
        # remove bang
        pattern=${pattern%!}
        ignore_case=""
    fi

    if [ -z "$extension" ]; then
        # grep -C = context
        git ls-files \
        | grep -v -E $FIND_FILE_IGNORE \
        | xargs grep -"$ignore_case"n "$pattern" -C $context --color=always 2>/dev/null \
        | grep -v "Binary file"
        return 0
    fi

    exclude=""
    if [[ "$extension" =~ !$ ]]; then
        # remove bang
        extension=${extension%!}
        git ls-files \
        | grep -v -E $FIND_FILE_IGNORE \
        | grep -v "$extension$" \
        | xargs grep -"$ignore_case"n "$pattern" -C $context --color=always 2>/dev/null \
        | grep -v "Binary file"
    else
        git ls-files \
        | grep -v -E $FIND_FILE_IGNORE \
        | grep "${extension}$" \
        | xargs grep -"$ignore_case"n "$pattern" -C $context --color=always 2>/dev/null \
        | grep -v "Binary file"
    fi
}

find_merge_conflict () {
    local conflicts="HEAD\s|<<<<<|>>>>>"
    local map_files="\.map"
    local minified_files="\.min\."

    if [ -z "$1" ]; then
        git ls-files \
        | xargs grep -n -P "$conflicts" --files-with-matches 2>/dev/null \
        | grep -v "Binary file" \
        | uniq
    elif [[ "$1" =~ "-v" ]]; then
        git ls-files \
        | grep -v -P "${map_files}|${minified_files}" \
        | xargs grep -n -P "$conflicts" -C 2 --color=always 2>/dev/null \
        | grep -v "Binary file"
    else
        echo Usage:
        echo "  $git_find_conflict [OPTIONS]"
        echo
        echo Options:
        echo "  -v          Verbose: shows merge conflict context."
        echo "              Also ignores minified and .map files"
        echo
    fi
}

alias $git_find=find_git_string
alias $git_find_conflict=find_merge_conflict
