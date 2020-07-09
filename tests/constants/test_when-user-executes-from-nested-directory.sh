#!/bin/bash

project_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_dir/tests/setup_environment.sh"
	cd "$test_environment/src" || exit 1
	# shellcheck source=./src/constants.sh
	source "$project_dir/src/constants.sh"
	cd "$test_environment" || exit 1
}

oneTimeTearDown() {
	teardown_environment
}

test_should_set_project_root_equal_parent_dir() {
	assertEquals "$test_environment" "$project_root"
}

# shellcheck disable=SC1090
. "$project_dir/shunit2/shunit2"
