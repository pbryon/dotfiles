file_find="ff"
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

    directory_name="%h"
    filename="%f"
    format="'${PWD}'/'$directory_name'/'$filename'\n"
    if [ -z "$extension" ]; then
        # grep -C = context
        find ./ -type f -printf $format \
        | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null \
        | grep -v "Binary file" \
        | sed -e "s|${PWD}/||g"
 
        return 0
    fi
   
    exclude=""
    if [[ "$extension" =~ !$ ]]; then
        # remove bang
        extension=${extension%!}
        find ./ -type f -printf $format \
        | grep -v "$extension'$" \
        | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null \
        | grep -v "Binary file" \
        | sed -e "s|${PWD}/||g"
    else
        find ./ -type f -printf $format \
        | grep "$extension'$" \
        | xargs grep -"$ignore_case"n "$pattern" -C 2 2>/dev/null \
        | grep -v "Binary file" \
        | sed -e "s|${PWD}/||g"

    fi
}

alias $file_find=find_file_string
