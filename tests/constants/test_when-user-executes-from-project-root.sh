#!/bin/bash

project_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_dir/tests/setup_environment.sh"
	# shellcheck source=./src/constants.sh
	source "$project_dir/src/constants.sh"
}

oneTimeTearDown() {
	teardown_environment
}

test_should_set_project_root_equal_cwd() {
	assertEquals "$(realpath .)" "$project_root"
}

# shellcheck disable=SC1090
. "$project_dir/shunit2/shunit2"
