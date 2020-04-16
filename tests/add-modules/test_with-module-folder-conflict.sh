#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	mkdir -p foopak_modules/rockerbacon_foopak-mock-module
	output=$(./foopak add rockerbacon/foopak-mock-module 2>&1); exit_code=$?
}

oneTimeTearDown() {
	rm -rf $environment_dir
}

test_should_exit_with_fail_code() {
	assertNotEquals "exited with success status." "0" "$exit_code"
}

test_should_inform_user_folder_already_exists() {
	assertNotNull "no output from program" "$output"

	error_message=$( \
		echo "$output" \
	| grep -oiE "could not add module.*'.*/foopak_modules/rockerbacon_foopak-mock-module' already exists" \
	)

	assertNotNull "output message not informative:\n$output" "$error_message"
}

. "$project_root/shunit2/shunit2"

