#!/bin/bash 

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
    if ! sudo lsmod | grep -w ${module} > /dev/null; then
    	echo "Module ${module} is not loaded."  
    	if ! sudo modinfo ${module} > /dev/null; then
   	     echo "Module ${module} is not installed."
    	else
             if sudo modprobe $module; then
  	        echo "Module ${module} is now loaded successfully."
   	     else
 		echo "Failed to load module ${module}."
   	     fi
        fi
   	echo "-----------------------------"
    fi
done

usernetes_version=$(curl -s https://api.github.com/repos/rootless-containers/usernetes/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

wget https://www.github.com/rootless-containers/usernetes/releases/download/${usernetes_version}/usernetes-x86_64.tbz

tar xjvf usernetes-x86_64.tbz
cd usernetes

chmod +x install.sh 
./install.sh 
