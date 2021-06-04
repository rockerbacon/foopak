#!/bin/bash

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
project_root=$(realpath "$script_dir/..")

cd "$project_root" || exit 1

rm -rf /tmp/foopak_test_environments

