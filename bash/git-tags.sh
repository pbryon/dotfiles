git_tags="git-tags"

print_tag_commit () {
    local tag_name=$1
    local commit=$2

    local beige="%C(#e6cc85)"
    local yellow="%C(#c9b620)"
    local light_blue="%C(#14d1db)"
    local reset_color="%C(reset)"
    local dim_white="%C(dim white)"

    local twenty_chars="%<(20,trunc)"
    local thirty_chars="%<(30,trunc)"

    local commit_hash="%h"
    local author_name="%an"
    local commit_date="%ci"
    local commit_message="%s"
    local format="  ${beige}${commit_hash}${reset_color}   ${twenty_chars}${yellow}${author_name}${reset_color}    ${thirty_chars}${light_blue}${commit_date}${reset_color}    ${dim_white}${commit_message}${reset_color}"

    git tag -n $tag_name
    git log --pretty=format:"$format" | grep "$commit"
}

show_git_tags () {
    OLD_IFS="$IFS"
    IFS=$'\n'

    local tag_hashes=$(git show-ref --tags --abbrev=7 --dereference | grep '{}')

    echo
    if [[ -z "$tag_hashes" ]]; then
        echo "> no tags!"
    else
        local dereferenced_commit="([a-f0-9]+)[[:space:]]refs/tags/(.+)\^\{\}"
        for hash in $tag_hashes; do
            if [[ "$hash" =~ $dereferenced_commit ]]; then
                print_tag_commit ${BASH_REMATCH[2]} ${BASH_REMATCH[1]}
            fi
        done
    fi

    echo
    IFS=$OLD_IFS
}

alias $git_tags=show_git_tags
