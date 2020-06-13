exec_module_command() {
	command_name=$1; shift

	# TODO cache command
	command_script=$(locate_command --absolute-path "$command_name")

	if [ -z "$command_script" ]; then
		echo "ERROR: unknown command '$command_name'" >&2
		exit 1
	fi

	"$command_script" $@
}

