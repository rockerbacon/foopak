#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"
	output=$(./foopak add --branch v3 rockerbacon/foopak-mock-module 2>&1); \
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
		"path 'foopak_modules/rockerbacon/foopak-mock-module' not found" \
		'[ -d "foopak_modules/rockerbacon/foopak-mock-module" ]'
}

test_should_be_able_to_execute_scripts() {
	expected_output="script-v3.1"
	actual_output=$(./foopak cmd-v3.1 2>&1)
	assertEquals \
		"module not correctly checked out:\n$output\n\n$gitmodules_content\n\n" \
		"$expected_output" \
		"$actual_output"
}

test_should_add_module_as_git_module() {
	assertContains \
		"module not correctly added to .gitmodules:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"foopak_modules/rockerbacon/foopak-mock-module"
}

test_should_add_module_using_relative_path() {
	assertNotContains \
		".gitmodules contains module added with absolute path:\n$output\n\n$gitmodules_content\n\n" \
		"$gitmodules_content" \
		"$project_root"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

