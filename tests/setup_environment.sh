#!/bin/bash

script_dir=$(realpath $(dirname $0))
project_root=$(realpath "$script_dir/..")

project_root_owner=$(stat --format=%U "$project_root")

if [ "$project_root_owner" != "$USER" ]; then
	echo "ERROR: user '$USER' does not own the project root located in '$project_root'" >&2
	return 1
fi

mkdir -p /tmp/foopak_test_environments
environment_dir=$(mktemp -d /tmp/foopak_test_environments/XXXXXX)

cp -R "$project_root"/* "$project_root"/.[!.]* $environment_dir/

"$environment_dir"/build.sh
mv "$environment_dir/build/foopak" "$environment_dir/foopak"

echo "$environment_dir"

