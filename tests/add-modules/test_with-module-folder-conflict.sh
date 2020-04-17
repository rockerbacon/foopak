#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	mkdir -p foopak_modules/rockerbacon_foopak-mock-module
	output=$(./foopak add rockerbacon/foopak-mock-module 2>&1); exit_code=$?
}

oneTimeTearDown() {
	cd "$project_root"
	rm -rf $environment_dir
}

test_should_exit_with_error_code() {
	assertNotEquals "exited with success code." "0" "$exit_code"
}

test_should_inform_user_folder_already_exists() {
	assertNotNull "no output from program" "$output"

	expected_error_message="could not add module: directory 'foopak_modules/rockerbacon_foopak-mock-module' already exists"

	assertContains "output not informative:\n$output\n\n" "$output" "$expected_error_message"
}

. "$project_root/shunit2/shunit2"

