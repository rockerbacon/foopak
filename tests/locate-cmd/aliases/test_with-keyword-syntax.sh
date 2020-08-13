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

script2 _alias_ script1

script3 _alias_ script1 'arg containing spaces'

EOF

	# shellcheck disable=SC1091
	source ./foopak source-libs

	locate_cmd script2
	exit_status=$?
}

oneTimeTearDown() {
	teardown_environment
}

test_should-execute-successfuly() {
	assertEquals \
		"exited with status '$exit_status'\n" \
		"0" \
		"$exit_status"
}

test_should-correctly-determine-module-root() {
	assertEquals \
		"$test_environment/foopak_modules/author/mock-module" \
		"${retval0:-}"
}

test_should-correctly-determine-module-name() {
	assertEquals \
		"author/mock-module" \
		"${retval1:-}"
}


test_should-correctly-determine-command() {
	# shellcheck disable=SC2124,SC2154
	cmd_str=${retval2[@]@Q}
	assertEquals \
		"'./foopak' 'script1'" \
		"$cmd_str"
}

# shellcheck disable=SC1090
. "$project_root/shunit2/shunit2"

