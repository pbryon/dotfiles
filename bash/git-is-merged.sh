git_is_merged="gim"
is_branch_merged () {
    if [[ $1 == "debug" ]]; then
       debug="yes"
    else
        debug=""
    fi
    OLD_IFS="$IFS"
    IFS=$'\n'

    log_branch_status Branch Commit Status
    log_branch_status "------" "------" "------"

    branches=$(git branch -a --color=never | grep remotes/origin)
    main_branch="main"
    for branch in $branches; do
        if [[ $branch =~ master ]]; then
            main_branch="master"
            continue
        elif [[ $branch =~ main ]]; then
            continue
        fi

        branch=$(echo -e "$branch" | tr -d '[:space:]')
        commit_cmd="git log -n 1 --pretty=format:%h $branch"
        if [ "$debug" ]; then
            echo Command: $commit_cmd
        fi

        latest_commit=$(git log -n 1 --pretty=format:%h $branch)
        if [ "$debug" ]; then
            echo "Latest commit on $branch: $latest_commit"
        fi

        if [ -z "$latest_commit" ]; then
            log_branch_status $branch "no commits on remote"
            continue
        fi

        local any_commits=$(git log remotes/origin/$main_branch | grep $latest_commit)
        if [ -z "$any_commits" ]; then
            log_branch_status $branch $latest_commit "not merged"
        else
            log_branch_status $branch $latest_commit "merged"
        fi
    done

    IFS=$OLD_IFS
}

log_branch_status() {
    printf "%-80s    %s    %s\n" $1 $2 ${3:-""}
}


alias $git_is_merged=is_branch_merged
