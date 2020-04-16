#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	./foopak add --alias "mock-alias" rockerbacon/foopak-mock-module
}

oneTimeTearDown() {
	rm -rf $environment_dir
}

test_should_add_module_in_correct_path() {
	assertTrue '[ -d "foopak_modules/mock-alias" ]'
}

test_should_correctly_link_files_in_module_root() {
	expected_link="$environment_dir/foopak_modules/mock-alias/script-1"
	actual_link=$(readlink script-1)
	assertEquals "$expected_link" "$actual_link"

	expected_output="script-1-v2"
	actual_output=$(./script-1)
	assertEquals "$expected_output" "$actual_output"
}

test_should_correctly_link_nested_files_to_project_root() {
	expected_link="$environment_dir/foopak_modules/mock-alias/depth1/depth2/nested-script"
	actual_link=$(readlink nested-script)
	assertEquals "$expected_link" "$actual_link"

	expected_output="nested-script-v2"
	actual_output=$(./nested-script)
	assertEquals "$expected_output" "$actual_output"
}

test_should_correctly_link_nested_files_to_nested_folders() {
	expected_link="$environment_dir/foopak_modules/mock-alias/depth1/depth2/nested-script"
	actual_link=$(readlink depth1/depth2/nested-script)
	assertEquals "$expected_link" "$actual_link"

	expected_output="nested-script-v2"
	actual_output=$(./depth1/depth2/nested-script)
	assertEquals "$expected_output" "$actual_output"
}

test_should_not_link_files_not_in_link_list() {
	file_in_project=$(find . -name unlinked-file -not -path './foopak_modules/*')
	assertNull "$file_in_project"
}

. "$project_root/shunit2/shunit2"

