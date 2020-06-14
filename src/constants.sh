# shellcheck shell=bash

project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
escaped_project_root=$(echo "$project_root" | sed 's/\//\\\//g')

