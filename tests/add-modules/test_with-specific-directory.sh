#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"
	output=$(./foopak add --dir "test_modules/subdir" rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?

	gitmodules_content=$(cat .gitmodules)
}

oneTimeTearDown() {
	teardown_environment
}

test_should_execute_without_errors() {
	assertEquals "program exited with error:\n$output\n\n" "0" "$exit_code"
}

test_should_add_module_in_correct_path() {
	assertTrue \
		"path 'test_modules/subdir/rockerbacon/foopak-mock-module' not found" \
		'[ -d "test_modules/subdir/rockerbacon/foopak-mock-module" ]'
}

test_should_not_be_able_to_execute_scripts_in_module_root() {
	expected_output="unknown command 'cmd-1'"
	actual_output=$(./foopak cmd-1 2>&1); exit_status=$?
	assertNotEquals "program exited with success code." "0" "$exit_status"
	assertContains "output not informative:\n$actual_output\n\n" "$actual_output" "$expected_output"
}

test_should_not_be_able_to_execute_scripts_in_nested_paths() {
	expected_output="unknown command 'nested-cmd'"
	actual_output=$(./foopak nested-cmd 2>&1); exit_status=$?
	assertNotEquals "program exited with success code." "0" "$exit_status"
	assertContains "output not informative:\n$actual_output\n\n" "$actual_output" "$expected_output"
}

test_should_not_be_able_to_execute_scripts_not_in_command_list() {
	expected_output="unknown command 'unlinked-file'"
	actual_output=$(./foopak unlinked-file 2>&1); exit_status=$?
	assertNotEquals "program exited with success code." "0" "$exit_status"
	assertContains "output not informative:\n$actual_output\n\n" "$actual_output" "$expected_output"
}

test_should_add_module_as_git_module() {
	assertContains \
		"module not correctly added to .gitmodules:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"test_modules/subdir/rockerbacon/foopak-mock-module"
}

test_should_add_module_using_relative_path() {
	assertNotContains \
		".gitmodules contains module added with absolute path:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"$project_root"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

