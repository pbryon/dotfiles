#!/bin/bash
# npm audit hook
frontend="src/Nomen.Presentation.Web"
echo "> Running npm audit..."
cd $frontend

error="npm not installed. Please install it first"
command -v npm >/dev/null || (echo $error >&2 && exit 1)
which npm >/dev/null || (echo $error >&2 && exit 1)

version=`npm --version`
if [[ $version != 6* ]]; then
    echo -e "--> npm version ($version) not high enough for audit"
    echo "    Upgrade it to at least 6.0.0 with:"
    echo "      npm install -g npm"
    exit 1
fi

npm audit >/dev/null || exit 1
echo "--> OK"
exit 0
