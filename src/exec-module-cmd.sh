# shellcheck shell=bash

exec_module_cmd() {
	command_name=$1; shift

	# TODO cache command
	command_script=$(locate_cmd --absolute-path "$command_name")

	if [ -z "$command_script" ]; then
		echo "ERROR: unknown command '$command_name'" >&2
		exit 1
	fi

	"$command_script" "$@"
}

