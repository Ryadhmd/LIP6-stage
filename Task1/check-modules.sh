#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Usage: $0 <module_file>"
  exit 1
fi

module_file="$1"

# Check if the file exists
if [[ ! -f "$module_file" ]]; then
  echo "Module file does not exist."
  exit 1
fi

# Read the module names from the file into an array
readarray -t modules < "$module_file"

# Loop through each module and check if it is loaded
for module in "${modules[@]}"; do
  if ! lsmod | grep -wq "${module}"; then
    echo "Module '${module}' is not loaded."
  fi
done



