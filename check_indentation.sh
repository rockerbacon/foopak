#!/bin/bash

check_indentation() {
	file=$1

	space_indentation=$(grep -n -E '^\s* ' "$file")

	if [ "$space_indentation" != "" ]; then
		echo "ERROR: file '$file' indented with spaces:" >&2
		echo "$space_indentation" >&2
		return 1
	fi

	return 0
}

failure=0
for file in "$@"; do
	echo "INFO: checking indentation for '$file'"
	check_indentation "$file"; exit_status=$?
	if [ "$exit_status" != "0" ]; then
		failure=1
	fi
done

exit $failure

