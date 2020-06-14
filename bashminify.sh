#!/bin/bash
print_error () {
echo -e "\033[0;31mERROR\033[0m:" "$@" >&2
}
input_file=$1
if [[ -z "$input_file" ]]; then
print_error "Expected 1 argument"
fi
declare -A already_expanded
expand_source () {
if [[ $# -ne 1 ]]; then
print_error "Bashminify error in \"expand_source\", nr. of arguments"
fi
local filename
filename=$(realpath "$1")
if [[ ! -f "${filename}" ]]; then
print_error "File \"${filename}\" does not exist."
exit 1
fi
if [[ ! -r "${filename}" ]]; then
print_error "Can't read file \"${filename}\"."
exit 1
fi
local base_source_dir
base_source_dir=$(dirname "$filename")
while read -r line; do
command="$(echo "$line" | cut -d" " -f1)"
if [[ "$command" == "source" || "$command" == "." ]]; then
include_file="$base_source_dir/$(echo "$line" | cut -d" " -f 2)"
if [[ "${already_expanded[$include_file]}" == "" ]]; then
already_expanded[$include_file]=true
expand_source "$include_file"
fi
else
echo "$line"
fi
done <"${filename}"
}
check_eof () {
line=$1
inside_eof=$2
is_eof_begin=$(echo "$line" | grep -E '<<\s*EOF')
if [[ -n "$is_eof_begin" ]]; then
inside_eof=true
else
is_eof_end=$(echo "$line" | grep -E '^\s*EOF')
if [[ -n "$is_eof_end" ]]; then
inside_eof=false
fi
fi
echo $inside_eof
}
strip_comments_and_white_spaces () {
sed -E -e 's/^\s+//' -e 's/\s+$//' -e '/^#.*$/d' -e '/^\s*$/d'
}
trim_white_spaces () {
sed -E -e 's/^\s+//' -e 's/\s+$//'
}
use_minimal_function_header () {
sed -E 's/function ([a-zA-Z0-9_]*) \{/\1 () {/'
}
grep --color=never -m 1 '#!' "$input_file"
{ IFS=$'\n'
inside_eof=false
expand_source "$input_file" | while read -r line; do
inside_eof=$(check_eof "$line" "$inside_eof")
if [[ "$inside_eof" == "false" ]]; then
echo "$line" |
strip_comments_and_white_spaces |
use_minimal_function_header
else
echo "$line"
fi
done
}
