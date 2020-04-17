#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	output=$(./foopak add rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?
}

oneTimeTearDown() {
	cd "$project_root"
	rm -rf $environment_dir
}

test_should_execute_without_errors() {
	assertEquals "program exited with error:\n$output\n\n" "0" "$exit_code"
}

test_should_add_module_in_correct_path() {
	assertTrue "[ -d foopak_modules/rockerbacon_foopak-mock-module ]"
}

test_should_be_able_to_execute_scripts_in_module_root() {
	expected_output="script-1-v4"
	actual_output=$(./foopak cmd-1 2>&1)
	assertEquals "did not execute script correctly" "$expected_output" "$actual_output"
}

test_should_be_able_to_execute_scripts_in_nested_paths() {
	expected_output="nested-script-v4"
	actual_output=$(./foopak nested-cmd 2>&1)
	assertEquals "did not execute script correctly" "$expected_output" "$actual_output"
}

test_should_not_be_able_to_execute_scripts_not_in_command_list() {
	expected_output="unknown command 'unlinked-file'"
	actual_output=$(./foopak unlinked-file 2>&1); exit_status=$?
	assertNotEquals "program exited with success code." "0" "$exit_status"
	assertContains "output not informative:\n$output\n\n" "$actual_output" "$expected_output"
}

. "$project_root/shunit2/shunit2"

