git_log () {
    git log -n "${1:-10}"
}

git_pretty_log() {
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
    local format="${beige}${commit_hash}${reset_color}     ${twenty_chars}${yellow}${author_name}${reset_color}    ${thirty_chars}${light_blue}${commit_date}${reset_color}    ${dim_white}${commit_message}${reset_color}"
    git log -n "${1:-200}" --pretty=format:"$format"
}

git_reflog() {
    git reflog | head -n "${1:-10}"
}

alias gl=git_log
alias glp=git_pretty_log
alias refs=git_reflog
