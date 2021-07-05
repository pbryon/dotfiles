work_dir () {
    if [ -z "$1" ]; then
        echo "$WORK_DIR"
    else
        echo "$WORK_DIR/$1"
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
