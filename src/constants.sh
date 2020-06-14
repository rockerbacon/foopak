#!/bin/bash

export project_root
project_root=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

export escaped_project_root
escaped_project_root=$(echo "$project_root" | sed 's/\//\\\//g')

