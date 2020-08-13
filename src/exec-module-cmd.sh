#!/bin/bash

source locate-cmd.sh

exec_module_cmd() {
	command_name=$1; shift

	# TODO cache command
	locate_cmd "$command_name"
	found_command=$?
	module_root=$retval0
	cmd=("${retval2[@]}")

	if [ "$found_command" == "1" ]; then
		echo "ERROR: unknown command '$command_name'" >&2
		return 1
	fi

	module_root="$module_root" "${cmd[@]}" "$@"
	return $?
}

