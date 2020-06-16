#!/bin/bash

ci_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

"$ci_dir/check_indentation.sh" &&
"$ci_dir/shellcheck.sh" &&
"$ci_dir/tests.sh" &&
echo -e "\nAll checks passed!"

