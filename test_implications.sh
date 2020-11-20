#!/usr/bin/env bash

mkdir -p inclusion_tests_cleaned

find "inclusion_tests/" -name "*_sub.aut" | while read -r fname; do
    other="$(echo "$fname" | sed -E "s/_sub/_sup/g")"
    if [[ ! -f "inclusion_tests_cleaned/$(basename "$fname")" ]] ||
       [[ ! -f "inclusion_tests_cleaned/$(basename "$other")" ]]; then
        # echo "Cleaning $fname and $other"
        (
            set -x
            pecan --heuristics --use-var-map="$fname" "$other" > temp
        )
        tail -n+2 "$fname" > "inclusion_tests_cleaned/$(basename "$fname")"
        tail -n+1 "temp" > "inclusion_tests_cleaned/$(basename "$other")"
    fi
done

find "inclusion_tests_cleaned/" -name "*_sub.aut" | while read -r fname; do
    other="$(echo "$fname" | sed -E "s/_sub/_sup/g")"
    ( set -x; autfilt -c "$fname" --included-in="$other" )
done


