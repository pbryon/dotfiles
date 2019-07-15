#!/bin/bash

script=$(basename $0)
error="$script: VS Code not installed. https://code.visualstudio.com/download"

command -v code >/dev/null || (echo $error >&2 && exit 1)
which code >/dev/null || (echo $error >&2 && exit 1)
code --help >/dev/null || (echo $error >&2 && exit 1)

file="vscode-extensions.txt"
code --list-extensions > $file
echo "--> extensions saved to $file"
