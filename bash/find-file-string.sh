file_find="ff"
not_like="not"
not_blank="not_empty"

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
    grep -v $pattern | not_empty
}

not_empty () {
    grep_with_context_empty="\-\-"
    grep -v $grep_with_context_empty | grep "\S"
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
        | grep --null-data -v "$extension$" \
        | xargs -0 grep -"$ignore_case"n "$pattern" -C 2 --color=always 2>/dev/null \
        | grep -v "$binary_file" \
        | sed -e "$remove_current_dir"
    else
        find . -type f -print0 \
        | grep --null-data "$extension$" \
        | xargs -0 grep -"$ignore_case"n "$pattern" -C 2 --color=always 2>/dev/null \
        | grep -v "$binary_file" \
        | sed -e "$remove_current_dir"

    fi
}

alias $file_find=find_file_string
alias $not_like=not
alias $not_blank=not_empty
