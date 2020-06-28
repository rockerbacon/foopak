#!/bin/bash

export project_root

until [ -d ".git" ]; do
	echo "$PWD" >&2
	if [ ! -O . ] || [ "$PWD" == "/" ]; then
		echo "ERROR: Project root directory could not be found." >&2
		exit 1
	fi

	cd ..
done

project_root=$PWD

export escaped_project_root
escaped_project_root=$(echo "$project_root" | sed 's/\//\\\//g')
