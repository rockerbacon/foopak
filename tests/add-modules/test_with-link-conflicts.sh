#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	touch 'script-1'
	output=$(./foopak add --alias 'mock-alias' rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?
}

oneTimeTearDown() {
	rm -rf $environment_dir
}

test_should_exit_with_error_code() {
	assertNotEquals "exited with success code." "0" "$exit_code"
}

test_should_inform_user_link_conflict() {
	assertNotNull "no output from program" "$output"

	error_message=$( \
		echo "$output" \
	|	grep -oiE "could not add module.*cannot link '.*/mock-alias/script-1' to '.*/script-1'.*file already exists" \
	)

	assertNotNull "output message not informative:\n$output" "$error_message"
}

. "$project_root/shunit2/shunit2"

