git_log () {
    git log -n "${1:-10}"
}

git_pretty_log() {
    git log -n "${1:-200}" --pretty=format:"%h    %an    %s"
}

git_reflog() {
    git reflog | head -n "${1:-10}"
}

alias gl=git_log
alias glp=git_pretty_log
alias refs=git_reflog
