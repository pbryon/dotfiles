# npm audit hook
frontend="src/Nomen.Presentation.Web"
echo "> Running npm audit..."
cd $frontend

error="npm not installed. Please install it first"
command -v npm >/dev/null 2>&1 || (echo $error >&2 && exit 1)
which npm >/dev/null 2>&1 || (echo $error >&2 && exit 1)

version=`npm --version`
if [[ $version != 6* ]]; then
    echo -e "--> npm version ($version) not high enough for audit" >&2
    echo "    Upgrade it to at least 6.0.0 with:" >&2
    echo "      npm install -g npm" >&2
    exit 1
fi

npm audit >/dev/null || exit 1
echo "--> OK"
exit 0
