#!/bin/bash

project_root=$(realpath $(dirname $0))
tests_dir="$project_root/tests"

echo -e "Initializing tests in '$tests_dir'\n"

test_scripts=$(find \
	"$tests_dir" \
	-name '*test_*.sh' \
	-exec echo {} \;
)

restore_ifs=$IFS
IFS=$'\n'

test_failed=false
for test_script in ${test_scripts[@]}; do
	echo "Running '$test_script'"

	bash "$test_script"; exit_status=$?

	if [ "$exit_status" != "0" ]; then
		test_failed=true
	fi
done

IFS=$restore_ifs

if [ "$test_failed" == "true" ]; then
	exit 1
fi

