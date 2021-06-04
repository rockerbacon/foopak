#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"
	mkdir -p foopak_modules/rockerbacon/foopak-mock-module
	output=$(./foopak add rockerbacon/foopak-mock-module 2>&1); exit_code=$?

	gitmodules_content=$(cat .gitmodules)
}

oneTimeTearDown() {
	teardown_environment
}

test_should_exit_with_error_code() {
	assertNotEquals "exited with success code." "0" "$exit_code"
}

test_should_inform_user_folder_already_exists() {
	assertNotNull "no output from program" "$output"

	expected_error_message="could not add module: directory 'foopak_modules/rockerbacon/foopak-mock-module' already exists"

	assertContains "output not informative:\n$output\n\n" "$output" "$expected_error_message"
}

test_should_not_add_module() {
	assertNotContains \
		"module was added to .gitmodules:\n$output\n\n$gitmodules_content\n" \
		"$gitmodules_content" \
		"rockerbacon/foopak-mock-module"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

