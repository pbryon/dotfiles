alias school="cd ${SCHOOL:-$PWD}"
if [ "$SCHOOL" != "$PWD" ]; then
    alias todo="cat $REPO/kdg/TODO.md | grep -v x | head -n 20"
    alias schedule="cat $REPO/kdg/P3.md | head -n 11"
fi
