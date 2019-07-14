gitall () {
    for project in ./**; do
        if [ ! -d $project ]; then
            continue;
        fi
        cd $project
        local branch=$(git branch 2>/dev/null)
        if [ -d ".git" -a "$branch" ]; then
            echo
            echo "> repo '${project##./}'..."
            git "$@" 
        fi
        cd ..
    done
}

alias pullall="gitall pull"
