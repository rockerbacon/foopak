#!/bin/bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

specific=$1

check_src() {
	{
		cd "$project_root/src" || exit 1
		shellcheck -x ./*
	}
	src_exit=$?
}

check_tests() {
	{
		cd "$project_root" || exit 1
		find "./tests/" -name '*.sh' -exec shellcheck -x {} +
	}
	tests_exit=$?
}

check_ci() {
	{
		cd "$project_root" || exit 1
		find "./ci" -maxdepth 1 -name '*.sh' -exec shellcheck -x {} +
	}
	ci_exit=$?
}

echo
echo "######## RUNNING SHELLCHECK ########"

case "$specific" in
	src)
		check_src
	;;

	tests)
		check_tests
	;;

	ci)
		check_ci
	;;

	*)
		check_src
		check_tests
		check_ci
	;;
esac

echo "######## RUNNING SHELLCHECK ########"

exit "${src_exit}${tests_exit}${ci_exit}"

