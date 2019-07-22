#!/bin/bash

script=$(basename $0)
error="$script: VS Code not installed. https://code.visualstudio.com/download"

command -v code >/dev/null || (echo $error >&2 && exit 1)
which code >/dev/null || (echo $error >&2 && exit 1)

file="vscode-extensions.txt"
path=dirname "$BASH_SOURCE"
full_file="$path/$file"

echo Updating VSCode extensions...
OLD_IFS="$IFS"
IFS=$'\n'
if [ ! -e "$full_file" ]; then
    echo $script: extension list missing: $file!
    return 1
fi

for extension in `cat $full_file`; do
    code --install-extension $extension --force
done

IFS=${OLD_IFS}
echo "--> done"
