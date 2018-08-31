#!/bin/bash
script=$(basename $0)
if [ ! -d "web" -o ! -d ".vim" ]; then
    echo "$script: Run from the repo directory!"
    exit 1
fi

if [ $1 = "all" ]; then
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

if [ "$all" -o "$bash" ]; then
    echo Updating bash...
    cp .bashrc.conf ~
    rm ~/.bashrc
    ln -s $PWD/.bashrc ~/.bashrc
    echo Reload your .bashrc
fi

if [ "$all" -o "$git" ]; then
    echo Updating git...
    cp .gitconfig ~
    cp .gitignore ~
fi

if [ "$all" -o "$vim" ]; then
    echo Updating vim...
    cp .vimrc ~
    cp -r .vim ~
fi
