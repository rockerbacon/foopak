#!/bin/bash

export project_root

current_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
finding_project_root=true

while [ "$finding_project_root" == "true" ]; do
	if [ "$USER" != "$(stat --format=%U "$current_dir")" ]; then
		echo "Project root directory could not be found."
		exit 1
	fi
	
	if [ -f "$current_dir/.git" ]; then
    		finding_project_root=false
    		project_root="$current_dir"
    	else
    		current_dir=$(dirname "$current_dir")
    	fi
done

export escaped_project_root
escaped_project_root=$(echo "$project_root" | sed 's/\//\\\//g')

