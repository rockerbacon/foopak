#!/bin/bash

project_root=$(realpath "$(dirname $0)/../..")

oneTimeSetUp() {
	environment_dir=$("$project_root/tests/setup_environment.sh")
	cd $environment_dir
	mkdir -p foopak_modules

	git submodule add \
		https://github.com/rockerbacon/foopak-mock-module \
		foopak_modules/rockerbacon/foopak-mock-module \
	&> /dev/null

	echo "unrelated_change" >> .gitignore
	touch unrelated_file

	output=$(./foopak remove rockerbacon/foopak-mock-module 2>&1); \
		exit_code=$?

	working_tree_state=$(git status)
}

oneTimeTearDown() {
	cd "$project_root"
	rm -rf $environment_dir
}

test_should_execute_successfuly() {
	assertEquals \
		"exited with error:\n$output\n\n" \
		0 \
		$exit_code
}

test_should_remove_module_folder() {
	assertFalse \
		"did not remove 'foopak_modules/rockerbacon/foopak-mock-module'." \
		"[ -d foopak_modules/rockerbacon/foopak-mock-module ]"
}

test_should_remove_module_from_gitmodules() {
	gitmodules=$(cat .gitmodules)
	assertNotContains \
		"module still listed in '.gitmodules'" \
		"$gitmodules" \
		"rockerbacon/foopak-mock-module"
}

test_should_remove_module_from_cache() {
	assertFalse \
		"module still cached in '.git/modules'" \
		"[ -d .git/modules/foopak_modules/rockerbacon/foopak-mock-module ]"
}

test_should_remove_module_from_config() {
	gitconfig=$(cat .git/config)
	assertNotContains \
		"module still listed in '.git/config'" \
		"$gitconfig" \
		"rockerbacon/foopak-mock-module"
}

test_should_remove_module_from_the_working_tree() {
	assertNotContains \
		"working tree has module related changes:\n$working_tree_state\n\n" \
		"$working_tree_state" \
		"foopak_modules"

	assertNotContains \
		"working tree has module related changes:\n$working_tree_state\n\n" \
		"$working_tree_state" \
		".gitmodules"
}

test_should_not_remove_unrelated_changes_from_the_working_tree() {
	assertContains \
		"removed unrelated change to '.gitignore' from the working tree" \
		"$working_tree_state" \
		".gitignore"
}

test_should_not_remove_unrelated_untracked_files_from_the_working_tree() {
	assertContains \
		"removed unrelated untracked file 'unrelated_file' from the working tree" \
		"$working_tree_state" \
		"unrelated_file"
}

. "$project_root/shunit2/shunit2"

