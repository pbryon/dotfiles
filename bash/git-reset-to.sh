git_reset_to="grt"
git_reset_to () {
    local target_commit=$1
    if [[ -z "$target_commit" ]]; then
        echo "Usage: $git_reset_to <target commit>"
        return 1
    fi
    
    local current_branch=`git rev-parse --abbrev-ref HEAD`
    if [[ -z "$current_branch" ]]; then
        echo Not currently on a branch!
        return 1
    fi

    read -p "Reset branch '$current_branch' to commit $target_commit? " -n 1 -r
	echo

    local commit_hash="%h"
    local match=`git log --pretty=format:$commit_hash | grep $target_commit`

	if [[ $REPLY =~ ^[Yy]$ ]]; then
	    if [[ -z "$match" ]]; then
	        echo No such commit: $target_commit!
	        return 1
	    fi
		echo Checking out $target_commit...
		git checkout $target_commit >/dev/null 2>&1
		echo Resetting HEAD to this commit...
		git push origin HEAD:$current_branch --force  >/dev/null 2>&1
		echo Checking out $current_branch again...
		git checkout $current_branch >/dev/null 2>&1
	fi
}

alias $git_reset_to=git_reset_to
