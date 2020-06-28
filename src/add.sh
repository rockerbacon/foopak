#!/bin/bash

source constants.sh
source remove.sh
source locate-cmd.sh

print_add_help() {
cat >&2 << EOF
Usage: ./foopak add [OPTIONS...] MODULE
Add module located in path MODULE from a git server to the project

MODULE:		path where the module resides in the git server. eg.:
		'rockerbacon/foopak-mock-module' adds the module from
		https://github.com/rockerbacon/foopak-mock-module

OPTIONS:
	--alias,-a	use different folder name for module
			default is MODULE with slashes
			replaced by underscores

	--tag,-t,	use specific tag or commit
	--commit,-c	default is the latest commit in the default remote

	--dir,-d	add module under different directory
			default is foopak_modules
			WARNING:
				modules outside 'foopak_modules'
				will not be scanned for commands

	--branch,-b	use specific branch
			default is the default remote branch

	--help,-h	print this help message and exit

EOF
}

add() {
	###   DEFAULTS    ###
	git_server="https://github.com"
	module_home_relative_dir="foopak_modules"
	module_options=()
	###   DEFAULTS   ###

	###   READ NAMED ARGS    ###
	reading_named_args=true
	while [ "$reading_named_args" == "true" ]; do
		option=$1
		case "$option" in
			--alias|-a)
				module_alias=$2; shift 2
			;;

			--branch|-b)
				module_options+=("-b" "$2"); shift 2
			;;

			--commit|-c|--tag|-t)
				module_version=$2; shift 2
			;;

			--dir|-d)
				module_home_relative_dir=$2; shift 2
			;;

			--help|-h)
				print_add_help
				return 0
			;;

			--*|-*)
				echo "ERROR: Unknown option '$option'" >&2
				echo >&2
				print_add_help >&2
				return 1
			;;

			*)
				reading_named_args=false
			;;
		esac
	done
	###   READ NAMED ARGS    ###

	###   READ POSITIONAL ARGS    ###
	module_path=$1; shift
	if [ "$module_path" == "" ]; then
		echo "ERROR: please specify a module to add" >&2
		echo >&2
		print_add_help
		return 1
	fi

	if [ -z "$module_alias" ]; then
		module_alias=$module_path
	fi
	###   READ POSITIONAL ARGS    ###

	module_parent_dir=$(dirname "$module_alias")
	if [ "${module_parent_dir:0:1}" != "." ]; then
		mkdir -p "$project_root/$module_parent_dir"
	fi

	module_install_path="$module_home_relative_dir/$module_alias"

	if [ -e "$module_install_path" ]; then
		echo "ERROR: could not add module: directory '$module_install_path' already exists" >&2
		return 1
	fi

	cd "$project_root" || return 1
	git submodule add "${module_options[@]}" "$git_server/$module_path" "$module_install_path"

	if [ -n "$module_version" ]; then
		restore_workdir=$PWD
		cd "$project_root/$module_install_path" || return 1
			git checkout "$module_version"; exit_status=$?
		cd "$restore_workdir" || return 1
		if [ "$exit_status" != "0" ]; then
			echo "ERROR: could not checkout version '$module_version', rolling back" >&2
			remove "$module_alias"
			return 1
		fi
	fi

	command_list="$module_install_path/foopak_meta/command_list.conf"

	if [ -f "$command_list" ]; then
		exec 3< "$command_list"
			# this might be useful later if the file standard changes
			# shellcheck disable=SC2034
			command_list_version=$(read -ru 3)

			while read -ru 3 command_config || [ -n "$command_config" ]; do
				[ -z "$command_config" ] && continue
				[ "${command_config:0:1}" == "#" ] && continue

				command_name=${command_config%%[[:space:]]*}

				locate_output=$(locate_cmd --exclude-dir "$module_install_path" "$command_name")
				found_command=$?

				if [ "$found_command" == "0" ]; then
					declare -A command_config="$locate_output"
					echo "ERROR: could not add module: command '$command_name' conflicts with module '${command_config[module_name]}'" >&2
					remove "$module_alias"
					return 1
				fi
			done
		exec 3>&-
	fi
}

