#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"
	./foopak add rockerbacon/foopak-mock-module 2>/dev/null 1>/dev/null
	output=$(./foopak add --alias 'mock-alias' rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?

	working_tree_state=$(git status)
	gitmodules_content=$(cat .gitmodules)
}

oneTimeTearDown() {
	teardown_environment
}

test_should_exit_with_error_code() {
	assertNotEquals "exited with success code." "0" "$exit_code"
}

test_should_inform_user_of_command_conflict() {
	assertNotNull "no output from program." "$output"

	expected_error_message="command 'cmd-1' conflicts with module 'rockerbacon/foopak-mock-module'"

	assertContains "missing proper error message:\n$output\n\n" "$output" "$expected_error_message"
}

test_should_rollback_module_addition() {
	assertNotContains \
		"module still listed in .gitmodules:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"mock-alias"

	assertNotContains \
		"working tree still lists module addition:\n$output\n\n$working_tree_state\n\n" \
		"$working_tree_state" \
		"mock-alias"
}

test_should_not_rollback_unrelated_modules() {
	assertContains \
		"unrelated module no longer listed in .gitmodules:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"rockerbacon/foopak-mock-module"

	assertContains \
		"unrelated module no longer in working tree:\n$output\n\n$working_tree_state\n\n" \
		"$working_tree_state" \
		"rockerbacon/foopak-mock-module"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

