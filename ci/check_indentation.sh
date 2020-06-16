#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

check_indentation() {
	file=$1

	echo "INFO: checking indentation for '$file'" >&2

	space_indentation=$(grep -n -E '^\s* ' "$file")

	if [ "$space_indentation" != "" ]; then
		echo "ERROR: file '$file' indented with spaces:"
		echo "$space_indentation" | tr ' ' '.'
		return 1
	fi

	return 0
}

echo
echo "######## CHECKING INDENTATION ########"

failure=$(
	find "$project_root" \
		-not -path "$project_root/shunit2/*" \
		-name '*.sh' |
	while read -r script; do
		check_indentation "$script"
	done
)

echo
if [ -n "$failure" ]; then
	echo -e "$failure\n"
	echo "Some files have incorrect indentation"
	exit 1
fi

echo "Everything looks fine"

echo "######## CHECKING INDENTATION ########"

