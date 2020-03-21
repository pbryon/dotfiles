#!/bin/bash

script=$(basename $0)
vscode_not_installed() {
    echo "$script: VS Code not installed. https://code.visualstudio.com/download" >&2
    exit 1
}

command -v code >/dev/null || vscode_not_installed
which code >/dev/null || vscode_not_installed
code --help >/dev/null || vscode_not_installed

file="extensions.txt"
path=$(dirname "$0")
full_file="$path/$file"

echo Saving VSCode extensions...
code --list-extensions > $full_file
echo "--> extensions saved to $full_file:"
cat "$full_file"
