git_is_merged="gim"
is_branch_merged () {
    git fetch >/dev/null
    if [[ $1 == "debug" ]]; then
       debug="yes"
    else
        debug=""
    fi
    OLD_IFS="$IFS"
    IFS=$'\n'

    log_branch_status Branch Commit Status
    log_branch_status "------" "------" "------"

    branches=$(git branch --remotes --all --color=never)
    main_branch="main"
    for branch in $branches; do
        if [[ $branch =~ master ]]; then
            main_branch="master"
            continue
        elif [[ $branch =~ main ]]; then
            continue
        fi

        branch=$(echo -e "$branch" | tr -d '[:space:]' | sed 's/remotes\///')
        commit_cmd="git log -n 1 --pretty=format:oneline $branch"
        if [ "$debug" ]; then
            echo "> Branch: $branch"
            echo "> Commit command: $commit_cmd"
        fi

        latest_commit=$(git log -n 1 --pretty=format:"%h %s" $branch)
        if [ "$debug" ]; then
            echo "> Latest commit on $branch: $latest_commit"
        fi

        if [ -z "$latest_commit" ]; then
            log_branch_status $branch "no commits on remote"
            continue
        fi

        local is_merged=$(git branch --remotes --merged HEAD | grep $branch)
        if [ "$debug" ]; then
            echo "> is merged: $is_merged"
        fi

        if [ -z "$is_merged" ]; then
            log_branch_status $branch $latest_commit "not merged"
        else
            log_branch_status $branch $latest_commit "merged"
        fi
    done

    IFS=$OLD_IFS
}

log_branch_status() {
    printf "%-70s    %-10s    %s\n" $1 ${3:-""} $2
}


alias $git_is_merged=is_branch_merged
