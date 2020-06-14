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
			locate_cmd "$@"
		;;

		*)
			exec_module_cmd "$command" "$@"
		;;
	esac
}

