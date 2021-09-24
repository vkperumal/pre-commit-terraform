#!/usr/bin/env bash
set -e

declare -a paths
declare -a tfvars_files

index=0

for file_with_path in "$@"; do
  # file_with_path="${file_with_path// /__REPLACED__SPACE__}"
  file_with_path=`find $file_with_path -type d -maxdepth 1 | grep -i $file_with_path/`

  paths[index]=$(dirname "$file_with_path")

  if [[ "$file_with_path" == *".tfvars" ]]; then
    tfvars_files+=("$file_with_path")
  fi

  let "index+=1"
done

for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
  path_uniq="${path_uniq//__REPLACED__SPACE__/ }"
  echo "$path_uniq"
  if [[ "$path_uniq" != "." ]]; then
    terraform-docs markdown table --output-file README.md --output-mode inject $path_uniq
  fi
done

# # terraform.tfvars are excluded by `terraform fmt`
# for tfvars_file in "${tfvars_files[@]}"; do
#   tfvars_file="${tfvars_file//__REPLACED__SPACE__/ }"

#   terraform fmt "$tfvars_file"
# done
