#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	./foopak add rockerbacon/foopak-mock-module 2>/dev/null 1>/dev/null
	output=$(./foopak add --alias 'mock-alias' rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?
}

oneTimeTearDown() {
	cd "$project_root"
	rm -rf $environment_dir
}

test_should_exit_with_error_code() {
	assertNotEquals "exited with success code." "0" "$exit_code"
}

test_should_inform_user_of_command_conflict() {
	assertNotNull "no output from program." "$output"

	expected_error_message="command 'cmd-1' conflicts with module 'rockerbacon/foopak-mock-module'"

	assertContains "missing proper error message:\n$output\n\n" "$output" "$expected_error_message"
}

. "$project_root/shunit2/shunit2"

