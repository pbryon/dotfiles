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
    start_from="$1"
    git diff $branch --name-only \
    | grep --after-context 5000 --max-count 1 --extended-regexp "$start_from"
}

diff_file_with_main () {
    if [ -z "$1" ]; then
        echo Usage:
        echo "$git_diff_main <file>"
        echo
        return 1
    fi

    branch=$(get_main_branch)
    delim=" "
    git diff "origin/$branch" --src-prefix "${branch^^}$delim" --dst-prefix "LOCAL$delim" "$1"
}

alias $git_diff_main=diff_file_with_main
alias $git_diff_files_only=diff_files_with_main
