#!/bin/bash
# pre-commit hook checking static files
files=$(git diff-index --cached --name-only --diff-filter=ACMR HEAD | grep project)
error=0

if [ ${#files} -eq 0 ]; then
    exit 0
fi

source_file="static-files"
for file in $files; do
    while read -r name; do
        echo $name
        if [[ $file =~ $name ]]; then
            echo File $file should be unchanged!
            error=1
        fi
    done < $source_file
done

exit $error
