#!/bin/bash
script=$(basename $0)
if [ ! -d "web" -o ! -d ".vim" ]; then
    echo "$script: Run from the repo directory!"
    exit 1
fi

if [ "$1" = "all" ]; then
    all=true
elif [[ $1 =~ bash ]]; then
    bash=true
elif [[ $1 =~ git ]]; then
    git=true
elif [[ $1 =~ vim ]]; then
    vim=true
elif [[ $1 =~ (vs)?code ]]; then
    code=true
else
    echo
    echo "Usage: $script <category>"
    echo
    echo "Categories (regex matched):"
    echo "  all     All of the below"
    echo "  bash    Update .bashrc and related files"
    echo "  code    Update VSCode extensions"
    echo "  git     Update .gitconfig and .gitignore"
    echo "  vim     Update .vimrc and .vim directory"
    echo "  vscode  As 'code'"
    echo
    exit 1
fi

arrow="-->"

create_symlink() {
    if [ ! "$1" ]; then
        echo "$script: error creating symlink '$1'"
        exit 1
    fi
    home_file="${HOME}/${1}"
    repo_file="${PWD}/${1}"
    confirm=false

    if [ -L $home_file ]; then
        target=$(readlink $home_file)
        if [ "$target" = "$repo_file" ]; then
            echo "${arrow} already up to date: ${home_file}"
            return
        fi

        echo "$home_file is a link but points to $target"
        confirm=true
    elif [ -e $home_file ]; then
        file_type="file"
        if [ -d $home_file ]; then
            file_type="directory"
        fi
        echo "$arrow $file_type $home_file exists"
        confirm=true
    fi

    if [ "$confirm" = true ]; then
        read -p "Replace with symlink [yn]? " -n 1 reply
        echo
        if [ "$reply" != "y" ]; then
            return
        fi
    fi

    if [[ -f $home_file && ! -L $home_file ]]; then
        rm "$home_file"
    elif [[ -d $home_file && ! -L $home_file ]]; then
        read -p "Force deletion [yn]? " -n 1 force_delete
        echo
        force="f"
        if [ "$force_delete" != "y" ]; then
            force=""
        fi
        rm "-r$force" "$home_file"
    fi

    ln -s $PWD/$1 ~/$1
    if [ "$!" = "0" ]; then
        echo "$arrow created symlink: ~/$1 -> $PWD/$1"
    fi
}

echo
if [ "$all" -o "$bash" ]; then
    echo Updating bash...
    conf_file=".bashrc.conf"
    if [ ! -e "${HOME}/${conf_file}" ]; then
        cp "$conf_file" "$HOME"
        echo "${arrow} copied file: ${conf_file}"
    fi
    create_symlink ".bashrc"
    create_symlink "bash"
    echo "$arrow please reload your .bashrc"
fi

if [ "$all" -o "$git" ]; then
    echo Updating git...
    create_symlink ".gitconfig"
    create_symlink ".gitignore"
fi

if [ "$all" -o "$vim" ]; then
    echo Updating vim...
    create_symlink ".vimrc"
    create_symlink ".vim"
fi

if [ "$all" -o "$code" ]; then
    ./vscode/update-extensions.sh
fi
echo
