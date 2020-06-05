refork="refork"

rebase_on_upstream () {
    local upstream="$1"
    if [[ -z "$upstream" ]]; then
        upstream="upstream"
    fi

    local url=`git remote get-url $upstream`
    if [[ -z "$url" ]]; then
        echo "No fetch URL found for upstream remote '$upstream'"
        return 1
    fi

    echo "> Fetching upstream..."
    git fetch "$upstream"
    echo "> Rebasing on upstream..."   
    git rebase "$upstream/master"
}

alias $refork=rebase_on_upstream
