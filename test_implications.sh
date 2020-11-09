#!/usr/bin/env bash

rm -rf inclusion_tests_cleaned
mkdir -p inclusion_tests_cleaned

find "inclusion_tests/" -name "*_sub.aut" | while read -r fname; do
    other="$(echo "$fname" | sed -E "s/_sub/_sup/g")"
    echo "Cleaning $fname and $other"
    pecan --use-var-map="$fname" "$other" > temp
    tail -n+2 "$fname" > "inclusion_tests_cleaned/$(basename "$fname")"
    tail -n+2 "temp" > "inclusion_tests_cleaned/$(basename "$other")"
    (
        set -x
        autfilt -c "inclusion_tests_cleaned/$(basename "$fname")" --included-in="inclusion_tests_cleaned/$(basename "$other")"
    )
done

