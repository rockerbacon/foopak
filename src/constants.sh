project_root=$(realpath $(dirname $0))
escaped_project_root=$(echo "$project_root" | sed 's/\//\\\//g')

