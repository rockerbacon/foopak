#!/bin/bash

source constants.sh

print_remove_help() {
cat >&2 << EOF
Usage: ./foopak remove [OPTIONS...] MODULE
Remove module located in path 'foopak_modules/MODULE'

MODULE:		module to remove
		use './foopak list' to see all installed modules

OPTIONS:
	--dir,-d	remove module under different directory
			default is foopak_modules

	--help,-h	print this help message and exit
EOF
}

remove() {
	###    DEFAULTS    ###
	module_home_relative_dir="foopak_modules"
	###    DEFAULTS    ###

	###    READ NAMED ARGS    ###
	reading_named_args=true
	while [ "$reading_named_args" == "true" ]; do
		option=$1
		case "$option" in
			--dir|-d)
				module_home_relative_dir=$2; shift 2
			;;

			--help|-h)
				print_remove_help
				exit 0
			;;

			--*|-*)
				echo "ERROR: Unknown option '$option'" >&2
				echo >&2
				print_remove_help >&2
				exit 1
			;;

			*)
				reading_named_args=false
			;;
		esac
	done
	###    READ NAMED ARGS    ###

	###    READ POSITIONAL ARGS    ###
	module_alias=$1; shift

	if [ -z "$module_alias" ]; then
		echo "ERROR: please specify the module to remove" >&2
		echo >&2
		print_remove_help
		exit 1
	fi
	###    READ POSITIONAL ARGS    ###
	module_relative_dir="$module_home_relative_dir/$module_alias"
	module_dir="$project_root/$module_relative_dir"

	if [ ! -d "$module_dir" ]; then
		echo "ERROR: module '$module_alias' not installed" >&2
		echo >&2
		print_remove_help
		exit 1
	fi

	git submodule deinit -f "$module_dir"
	git rm -f "$module_dir"
	rm -rf "$project_root/.git/modules/$module_relative_dir"
}

