#!/bin/bash
## dotnet build pre-commit hook
extensions="\.(cs|csproj|sln)$"
files=$(git diff-index --cached --name-only --diff-filter=ACMR HEAD | grep -P $extensions)
if [ ${#files} -eq 0 ]; then
    exit 0
fi

script=$(basename $0)
error="$script: dotnet CLI not installed. See https://github.com/dotnet/cli/blob/master/README.md"
command -v dotnet >/dev/null || (echo $error >&2 && exit 1)
which dotnet >/dev/null || (echo $error >&2 && exit 1)
dotnet --help >/dev/null || exit 1

project="Nomen.sln"
dotnet build --verbosity quiet $project
