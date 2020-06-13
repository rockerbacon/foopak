main() {
	command=$1; shift
	case "$command" in
		remove|r)
			remove $@
		;;

		add|a)
			add $@
		;;

		locate-cmd)
			locate_command $@
		;;

		*)
			exec_module_command $command $@
		;;
	esac
}

