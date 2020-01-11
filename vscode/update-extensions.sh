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

echo Updating VSCode extensions...
OLD_IFS="$IFS"
IFS=$'\n'
if [ ! -e "$full_file" ]; then
    echo "$script: extension list missing: $file!"
    exit 1
fi

for extension in `cat $full_file`; do
    echo -n "    "
    code --install-extension $extension --force | grep -v "Installing extensions..."
done

IFS=${OLD_IFS}
echo "--> done"
