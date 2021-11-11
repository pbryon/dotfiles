git_diff_files_only="gdf"
git_diff_main="gdm"

get_main_branch () {
    main_branches=(main master)
    for branch in "${main_branches[@]}"; do
        exists=`git rev-parse --verify $branch 2>/dev/null` 
        if [ "$exists" ]; then
            echo "$branch"
            break
        fi
    done
}

diff_files_with_main () {
    branch=$(get_main_branch)
    default_context="10"
    if [[ "$1" == "--help" ]]; then
        echo Usage:
        echo "  $git_diff_files_only <pattern> <context>"
        echo
        echo "Arguments:"
        echo "  pattern         Start from files matching this extended regex pattern"
        echo "  context         Default: $default_context. The amount of lines to show after a match"
        echo
        return 1
    fi

    start_from="$1"
    context=${2:-$default_context}
    diff=`git diff $branch --name-only`
    if [ -z "$start_from" ]; then
        echo -e "$diff"
    else
        output=`echo -e "$diff" | grep --after-context "$context" --max-count 1 --extended-regexp "$start_from"`

        for line in "$output"; do
            echo -e "$line\n"
        done

        all_lines=`echo -e "$diff" | wc -l`
        if [ $all_lines -gt $context ]; then
            echo ...
            echo "[showed $context / $all_lines lines]"
        fi
    fi
}

diff_file_with_main () {
    if [ -z "$1" ]; then
        echo Usage:
        echo "  $git_diff_main <file>"
        echo
        return 1
    fi

    if [ -e "$1" ]; then
        branch=$(get_main_branch)
        delim=" "
        git diff "origin/$branch" --src-prefix "${branch^^}$delim" --dst-prefix "LOCAL$delim" "$1"
    else
        echo File removed locally
        return 1
    fi
}

alias $git_diff_main=diff_file_with_main
alias $git_diff_files_only=diff_files_with_main
