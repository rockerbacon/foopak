#!/bin/bash

project_root=$(realpath $(dirname $0))
tests_dir="$project_root/tests"

echo "Initializing tests in '$tests_dir'"

find \
	"$tests_dir" \
	-name '*test_*.sh' \
	-exec bash {} \;

