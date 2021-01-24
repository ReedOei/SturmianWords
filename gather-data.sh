#!/usr/bin/env bash

set -e

date
git rev-parse HEAD

name_map="$1"
fname="$2"

# Clear the file
> .pred_names

cat "$name_map" | sort -n -k5 -t, | while read -r line; do
    display_name="$(echo "$line" | cut -f1 -d",")"
    name="$(echo "$line" | cut -f2 -d",")"
    should_display="$(echo "$line" | cut -f3 -d",")"
    complexity="$(echo "$line" | cut -f4 -d",")"
    atoms="$(echo "$line" | cut -f5 -d",")"

    if [[ -z "$complexity" ]]; then
        complexity="\\text{\\reed{TODO}}"
    fi

    if [[ -z "$atoms" ]]; then
        atoms="\\text{\\reed{TODO}}"
    fi

    if [[ "$should_display" == "true" ]]; then
        runtime="$(printf %.1f "$(grep -F "Runtime for $name is" "$fname" | head -1 | sed -E "s/.*Runtime for (.*) is (.*)/\2/g")")"
        states="$(grep -F "Max states for $name is" "$fname" | head -1 | sed -E "s/.*Max states for (.*) is (.*)/\2/g")"
        edges="$(grep -F "Max edges for $name is" "$fname" | head -1 | sed -E "s/.*Max edges for (.*) is (.*)/\2/g")"

        if [[ -f "automata/$name.aut" ]]; then
            stats="$(tail -n+2 "automata/$name.aut" | autfilt --stats="%s,%e")"
            final_states="$(echo "$stats" | cut -f1 -d",")"
            final_edges="$(echo "$stats" | cut -f2 -d",")"
            echo "$display_name & \$$atoms\$ & \$$complexity\$ & \$$runtime\$ & \$$states\$ & \$$edges\$ & \$$final_states\$ & \$$final_edges\$ \\\\"
        else
            echo "$display_name & \$$atoms\$ & \$$complexity\$ & \$$runtime\$ & \$$states\$ & \$$edges\$ \\\\"
        fi
    fi

    echo "$name" >> .pred_names
done

missing_names="$(grep -w "Runtime for.*" "$fname" | sed -E "s/.*Runtime for (.*) is (.*)/\1/g" | grep -vxFf .pred_names)"
if [[ -n "$missing_names" ]]; then
    echo "[WARNING]: Missing names found:"
    echo "$missing_names"
fi

