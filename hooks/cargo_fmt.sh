#!/usr/bin/env bash


set -e

HAS_ISSUES=0
FIRST_FILE=1

for file in $(git diff --name-only --staged); do
    FMT_RESULT="$(rustfmt --skip-children --force --write-mode diff $file 2>/dev/null || true)"
    if [ "$FMT_RESULT" != "" ]; then
        if [ $FIRST_FILE -eq 0 ]; then
            echo -n ", "
        fi
        echo -n "$file"
        HAS_ISSUES=1
        FIRST_FILE=0
    fi
done

if [ $HAS_ISSUES -eq 0 ]; then
    exit 0
fi

echo ". Your code has formatting issues in files listed above. Call rustfmt manually."
exit 1
