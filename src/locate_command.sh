locate_command() {
	if [ ! -d "$project_root/foopak_modules" ]; then
		return 0
	fi

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
			--exclude-dir)
				extra_tests+=("-not -path '$project_root/$2/*'"); shift 2
			;;

			--absolute-path)
				relative_path=false; shift 1
			;;

			--print-module)
				output_mode="module"; shift 1
			;;

			--*|-*)
				echo "ERROR: unknown option '$option'" >&2
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

	find_query=" \
					find '$project_root/foopak_modules' \
						${extra_tests[*]} \
						-path '*/foopak_meta/*' \
						-name command_list.conf \
		-exec	grep --with-filename -E '^$command_name\s' {} + \
	"
	command_location=$(bash -c "$find_query")

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

