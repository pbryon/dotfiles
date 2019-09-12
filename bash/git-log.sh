git_log () {
    git log -n "${1:-10}"
}

git_pretty_log() {
    git log -n "${1:-200}" --pretty=format:"%C(dim green)%h%C(reset)     %<(20,trunc)%C(dim yellow)%an%C(reset)    %C(dim white)%s%C(reset)"
}

git_reflog() {
    git reflog | head -n "${1:-10}"
}

alias gl=git_log
alias glp=git_pretty_log
alias refs=git_reflog
