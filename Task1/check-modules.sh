
#!/bin/bash

# Check if the file path argument is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <module_file>"
  exit 1
fi


if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
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
	
	if ! modinfo $module &> /dev/null; then
    		echo "Module $module is not installed."
	else
    		echo "Module $module is installed."
    	if modprobe $module; then
       		echo "Module $module loaded successfully."
    	else
      	 	echo "Failed to load module $module."
    	fi   	 
    	echo "-----------------------------"
	fi
  fi  
done


