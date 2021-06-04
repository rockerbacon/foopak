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

	--help,-h	print this help message and exit
EOF
}

locate_cmd() {
	###    DEFAULTS    ###
	extra_tests=()
	###    DEFAULTS    ###

	###    READ NAMED ARGS    ###
	reading_named_args=true
	while [ "$reading_named_args" == "true" ]; do
		option=$1
		case "$option" in
			--exclude-dir)
				extra_tests+=("-not -path '$project_root/$2/*'"); shift 2
			;;

			--help|-h)
				print_locate_cmd_help
				return 0
			;;

			--*|-*)
				echo "ERROR: unknown option '$option'" >&2
				return 1
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
		echo "WARN: no modules installed" >&2
		return 1
	fi

	find_query=" \
					find '$project_root/foopak_modules' \
						${extra_tests[*]} \
						-path '*/foopak_meta/*' \
						-name command_list.conf \
		-exec	grep --with-filename -E '^$command_name\s' {} + \
	"
	command_config_line=$(bash -c "$find_query")

	if [ -z "$command_config_line" ]; then
		return 1
	fi

	config_file=${command_config_line%%:*}
	declare -a config="(${command_config_line#*:})"

	module_root=$(realpath "$(dirname "$config_file")/../")
	module_name=${module_root#$project_root/foopak_modules/}

	i=1
	command_type=${config[$i]}
	case "$command_type" in
		_alias_)
			((i++))
			retval2=("${BASH_SOURCE[0]}" "${config[@]:$i}")
		;;

		_executable_)
			((i++))
		;&
		*)
			retval2=("$module_root/${config[$i]}")
		;;
	esac

	export retval0=$module_root
	export retval1=$module_name
	export retval2
}

