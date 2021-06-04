#!/bin/bash

source locate-cmd.sh
source remove.sh
source add.sh
source exec-module-cmd.sh

main() {
	command=$1; shift
	case "$command" in
		remove|r)
			remove "$@"
		;;

		add|a)
			add "$@"
		;;

		locate-cmd)
			if locate_cmd "$@"; then
				echo "module_root=$retval0"
				echo "module_name=$retval1"
				# shellcheck disable=SC2145
				echo "cmd=${retval2[@]@Q}"
			else
				echo "Command not found" >&2
			fi
		;;

		source-libs)
			# do nothing, this is just for lib initialization
		;;

		*)
			exec_module_cmd "$command" "$@"
		;;
	esac
}

main "$@"

