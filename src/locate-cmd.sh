#!/bin/bash

source constants.sh

print_locate_cmd_help() {
cat >&2 <<EOF
Usage: ./foopak locate-cmd [OPTIONS...] COMMAND
Scan installed modules to locate a command

COMMAND:	command to be located

OPTIONS:
	--absolute-path	print absolute path to the command
			instead of the relative path

	--exclude-dir	ignore a specific directory
			when searching for the command.
			Directory is relative to the root of the project

	--print-module	print path to the module
			instead of the path to the script
			which implements the command

	--debug,-d	print debug information

	--help,-h	print this help message and exit
EOF
}

locate_cmd() {
	###    DEFAULTS    ###
	extra_tests=()
	output_mode="script"
	relative_path=true
	###    DEFAULTS    ###

	###    READ NAMED ARGS    ###
	reading_named_args=true
	while [ "$reading_named_args" == "true" ]; do
		option=$1
		case "$option" in
			--absolute-path)
				relative_path=false; shift 1
			;;

			--debug|-d)
				debug=true; shift 1
			;;

			--exclude-dir)
				extra_tests+=("-not -path '$project_root/$2/*'"); shift 2
			;;

			--print-module)
				output_mode="module"; shift 1
			;;

			--help|-h)
				print_locate_cmd_help
				exit 0
			;;

			--*|-*)
				echo "ERROR: unknown option '$option'" >&2
				exit 1
			;;

			*)
				reading_named_args=false
			;;
		esac
	done
	###    READ NAMED ARGS    ###

	###    READ POSITIONAL ARGS    ###
	command_name=$1; shift
	###    READ POSITIONAL ARGS    ###

	if [ ! -d "$project_root/foopak_modules" ]; then
		echo "ERROR: no modules installed" >&2
		return 0
	fi

	find_query=" \
					find '$project_root/foopak_modules' \
						${extra_tests[*]} \
						-path '*/foopak_meta/*' \
						-name command_list.conf \
		-exec	grep --with-filename -E '^$command_name\s' {} + \
	"
	command_location=$(bash -c "$find_query")

	if [ -z "$command_location" ] && [ "$debug" == "true" ]; then
		echo "DEBUG: could not find command" >&2
		exit 0
	fi

	if [ "$relative_path" == "true" ]; then
		command_location=$(echo "$command_location" | sed "s/$escaped_project_root\/foopak_modules\///")
	fi

	case "$output_mode" in
		script)
				echo "$command_location" \
			|	sed "s/foopak_meta\/command_list\.conf.*\s//"
		;;

		module)
				echo "$command_location" \
			|	sed "s/\/foopak_meta.*$//"
		;;
	esac
}

