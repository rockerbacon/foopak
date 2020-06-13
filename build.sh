#!/bin/bash

project_root=$(dirname $(realpath "$0"))
src_dir="$project_root/src"

if [ -z "$output_file" ]; then
	output_file="$project_root/build/foopak"
fi

mkdir -p $(dirname "$output_file")

build_list=( \
	"$src_dir/constants.sh" \
	"$src_dir/locate_command.sh" \
	"$src_dir/remove.sh" \
	"$src_dir/add.sh" \
	"$src_dir/exec_module_command.sh" \
	"$src_dir/main.sh" \
)

echo '#!/bin/bash' > "$output_file"
cat "${build_list[@]}" >> "$output_file"
echo 'main "$@"' >> "$output_file"

chmod +x "$output_file"

