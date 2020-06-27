#!/bin/bash

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
dev_environment=$(realpath "$script_dir/..")

mkdir -p /tmp/foopak_test_environments
test_environment=$(mktemp -d /tmp/foopak_test_environments/XXXXXX)

reset_environment() {
	make --directory "$dev_environment"

	rm -rf "${test_environment:?}"/* "${test_environment:?}"/.[!.]*

	cp -R "${dev_environment:?}"/* "${dev_environment:?}"/.[!.]* "${test_environment:?}/"

	mv -f "$test_environment/build/foopak" "$test_environment/foopak"
}

teardown_environment() {
	cd "$dev_environment" || return 1
	rm -rf "$test_environment"
}

reset_environment
cd "$test_environment" || return 1

