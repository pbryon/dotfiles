export WORK_DIR="radahr"

work_dir () {
    base_path="${REPO}/${WORK_DIR}"
    if [ -z "$1" ]; then
        echo "$base_path"
    else
        echo "$base_path/$1"
    fi
}

goto_web () {
   subpath=$(work_dir "source/radahr-web-app-js")
   cd "$subpath"
}

goto_bff () {
    subpath=$(work_dir "source/radahr-bff-graphql-js")
    cd "$subpath"
}

alias web=goto_web
alias bff=goto_bff
