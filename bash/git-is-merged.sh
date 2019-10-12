git_is_merged="gim"
is_branch_merged () {
    OLD_IFS="$IFS"
    IFS=$'\n'

    branches=`git branch -a | grep remotes/origin`
    for branch in $branches; do
        if [[ $branch =~ master ]]; then
            continue
        fi

        local latest_commit=`git log -n 1 --pretty=format:%h 2>/dev/null`

        if [ -z "$latest_commit" ]; then
            log_branch_status $branch "no commits on remote"
            continue
        fi

        local any_commits=`git log origin/master | grep $latest_commit 2>/dev/null`
        if [ -z "$any_commits" ]; then
            log_branch_status $branch "not merged"
        else
            log_branch_status $branch "merged"
        fi
    done

    IFS=$OLD_IFS
}

log_branch_status() {
    printf "%-80s  %s\n" $1 $2
}


alias $git_is_merged=is_branch_merged
