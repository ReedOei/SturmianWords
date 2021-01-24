#!/usr/bin/env bash

set -e

date
git rev-parse HEAD

name_map="$1"
fname="$2"

# Clear the file
> .pred_names

cat "$name_map" | while read -r line; do
    display_name="$(echo "$line" | cut -f1 -d",")"
    name="$(echo "$line" | cut -f2 -d",")"
    should_display="$(echo "$line" | cut -f3 -d",")"
    complexity="$(echo "$line" | cut -f4 -d",")"

    if [[ -z "$complexity" ]]; then
        complexity="\\text{\\reed{TODO}}"
    fi

    if [[ "$should_display" == "true" ]]; then
        runtime="$(printf %.2f "$(grep -w "Runtime for $name is" "$fname" | head -1 | sed -E "s/.*Runtime for (.*) is (.*)/\2/g")")"
        states="$(grep -w "Max states for $name is" "$fname" | head -1 | sed -E "s/.*Max states for (.*) is (.*)/\2/g")"
        edges="$(grep -w "Max edges for $name is" "$fname" | head -1 | sed -E "s/.*Max edges for (.*) is (.*)/\2/g")"
        echo "$display_name & \$$complexity\$ & \$$runtime\$ & \$$states\$ & \$$edges\$ \\\\"
    fi

    echo "$name" >> .pred_names
done

missing_names="$(grep -w "Runtime for.*" "$fname" | sed -E "s/.*Runtime for (.*) is (.*)/\1/g" | grep -vxFf .pred_names)"
if [[ -n "$missing_names" ]]; then
    echo "[WARNING]: Missing names found:"
    echo "$missing_names"
fi

