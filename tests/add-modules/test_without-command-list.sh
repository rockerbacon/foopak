#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"
	output=$(./foopak add --commit 30fc847057f4348cb6227c181de3671c19ee2457 rockerbacon/foopak-mock-module 2>&1); \
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

