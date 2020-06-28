#!/bin/bash

source locate-cmd.sh

exec_module_cmd() {
	command_name=$1; shift

	# TODO cache command
	locate_output=$(locate_cmd "$command_name")
	found_command=$?

	if [ "$found_command" == "1" ]; then
		echo "ERROR: unknown command '$command_name'" >&2
		return 1
	fi

	declare -A command_config="$locate_output"
	declare -a cmd="${command_config[cmd]}"


	module_root="${command_config[1]}" "${cmd[@]}" "$@"
	return $?
}

