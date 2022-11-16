git_fresh_from_main="gffm"
git_fresh_from_dev="gffd"
git_fresh_from_staging="gffs"

function git_fresh_from_main() {
    local current_branch=`git rev-parse --abbrev-ref HEAD`
    if [[ -z "$current_branch" ]]; then
        echo Not currently on a branch!
        return 1
    fi

    echo Checking out $MAIN_BRANCH...
    git checkout $MAIN_BRANCH >/dev/null 2>&1
    echo Pulling changes...
    git pull

    read -p "Remove branch '$current_branch'? " -n 1 -r
	echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git branch -D $current_branch
    fi

    if [[ -z "$1" ]]; then
        return 0
    fi

    echo Creating new branch $1...
    git checkout -b $1
}

function git_fresh_from_development() {
    local current_branch=`git rev-parse --abbrev-ref HEAD`
    if [[ -z "$current_branch" ]]; then
        echo Not currently on a branch!
        return 1
    fi

    echo Checking out $DEV_BRANCH...
    git checkout $DEV_BRANCH >/dev/null 2>&1
    echo Pulling changes...
    git pull

    read -p "Remove branch '$current_branch'? " -n 1 -r
	echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git branch -D $current_branch
    fi

    if [[ -z "$1" ]]; then
        return 0
    fi

    echo Creating new branch $1...
    git checkout -b $1
}

function git_fresh_from_staging() {
    local current_branch=`git rev-parse --abbrev-ref HEAD`
    if [[ -z "$current_branch" ]]; then
        echo Not currently on a branch!
        return 1
    fi

    echo Checking out $STAGING_BRANCH...
    git checkout $STAGING_BRANCH >/dev/null 2>&1
    echo Pulling changes...
    git pull

    read -p "Remove branch '$current_branch'? " -n 1 -r
	echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git branch -D $current_branch
    fi

    if [[ -z "$1" ]]; then
        return 0
    fi

    echo Creating new branch $1...
    git checkout -b $1
}

alias $git_fresh_from_main=git_fresh_from_main
alias $git_fresh_from_dev=git_fresh_from_development
alias $git_fresh_from_staging=git_fresh_from_staging
