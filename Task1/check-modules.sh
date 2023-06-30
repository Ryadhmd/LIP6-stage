#!/bin/bash

# Check if the file path argument is provided
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

# Read the module names from the file
modules=$(cat "$module_file")

# Loop through each module and check if it is loaded
for module in $modules; do
  if ! lsmod | grep -w "${module}"; then
    echo "Module '${module}' is not loaded."
  fi
done

