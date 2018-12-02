#!/bin/bash
# pre-push npm audit hook
frontend="src/Nomen.Presentation.Web" # replace as needed
echo "> Running npm audit..."
if [ $frontend ]; then
    cd $frontend
fi
npm audit >/dev/null 2>&1 || exit 1
echo "--> OK"
exit 0
