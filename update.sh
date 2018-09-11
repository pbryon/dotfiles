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
else
    echo
    echo "Usage: $script <category>"
    echo
    echo "Categories (regex matched):"
    echo "  all     All of the below"
    echo "  bash    Update .bashrc and related files"
    echo "  git     Update .gitconfig and .gitignore"
    echo "  vim     Update .vimrc and .vim directory"
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
    elif [ -f $home_file ]; then
        echo "$home_file exists"
        confirm=true
    fi

    if [ "$confirm" = true ]; then
        read -p "Replace [yn]? " -n 1 reply
        echo
        if [ "$reply" != "y" ]; then
            return
        fi
    fi

    if [[ -e $home_file && ! -L $home_file ]]; then
        rm "$home_file"
    fi

    ln -s $PWD/$1 ~/$1
    if [ !"$!" ]; then
        echo "$arrow created symlink: ~/$1 -> $PWD/$1"
    fi
}

if [ "$all" -o "$bash" ]; then
    echo
    echo Updating bash...
    cp .bashrc.conf ~
    create_symlink ".bashrc"
    echo "$arrow please reload your .bashrc"
fi

if [ "$all" -o "$git" ]; then
    echo
    echo Updating git...
    create_symlink ".gitconfig"
    create_symlink ".gitignore"
fi

if [ "$all" -o "$vim" ]; then
    echo
    echo Updating vim...
    create_symlink ".vimrc"
    echo "$arrow copying .vim directory..."
    cp -r .vim ~
fi
echo
