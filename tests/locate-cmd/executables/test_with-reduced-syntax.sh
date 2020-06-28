#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../..")

oneTimeSetUp() {
	# shellcheck source=./tests/setup_environment.sh
	source "$project_root/tests/setup_environment.sh"

	mkdir -p foopak_modules/author/mock-module/foopak_meta
	cat > foopak_modules/author/mock-module/foopak_meta/command_list.conf << EOF
format-v1

# comment
script1 path/to/script1

script2 _executable_ nested/path/to/script2

script3 'path/containing spaces/script3'

EOF

	output=$(./foopak locate-cmd script1 2>&1)
	exit_status=$?

	if [ "$exit_status" == "0" ]; then
		declare -gA script_location="$output"
	fi
}

oneTimeTearDown() {
	teardown_environment
}

test_should-execute-successfuly() {
	assertEquals \
		"exited with status '$exit_status':\n$output\n" \
		"0" \
		"$exit_status"
}

test_should-correctly-determine-module-name() {
	assertEquals \
		"author/mock-module" \
		"${script_location[module_name]}"
}

test_should-correctly-determine-module-root() {
	assertEquals \
		"$test_environment/foopak_modules/author/mock-module" \
		"${script_location[module_root]}"
}

test_should-correctly-determine-command() {
	assertEquals \
		"('$test_environment/foopak_modules/author/mock-module/path/to/script1')" \
		"${script_location[cmd]}"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

