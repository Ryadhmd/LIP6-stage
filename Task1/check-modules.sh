#!/bin/bash
##This is actually installed usernetes requirements

# Check if the file path argument is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <module_file>"
  exit 1
fi


#if [[ $EUID -ne 0 ]]; then
#  echo "This script must be run as root."
#  exit 1
#fi

# Get the current kernel version
kernel_version=$(uname -r)

# Extract the major and minor version numbers
major_version=$(echo "$kernel_version" | cut -d. -f1)
minor_version=$(echo "$kernel_version" | cut -d. -f2)

# Compare the version numbers
if ! ([ "$major_version" -gt 4 ] || ([ "$major_version" -eq 4 ] && [ "$minor_version" -ge 18 ])); then
  echo "Kernel version is less than 4.18."
  exit 1
fi

# Check if cgroup v2 are used

FILE=/sys/fs/cgroup/cgroup.controllers
if [ ! -f $FILE ]; then
  echo "The cgroup version used is v1"
  exit 1
fi
## TO DO : enable cgroup v2

# Check systemd version
systemd_version=$(systemctl --version | head -n 1 | awk '{print $2}')
version_required=242
if [ $systemd_version -lt $version_required ]; then
   echo "Systemd version is less than $version"
   exit 1
fi

packages=(fuse3 iptables conntrack uidmap)
for package in ${packages[@]}; do
	if ! dpkg -s $package &> /dev/null; then
   	echo "The package $package is not installed"
   	echo "Going to install $package..."
   	apt update
   	if ! (sudo apt install -y $package); then
  		   echo "Failed to install $package"
      	exit 1
   	fi   
	fi
done

user_entry=$(grep "^$(whoami):" /etc/subuid | cut -d ':' -f 3)
group_entry=$(grep "^$(whoami):" /etc/subgid | cut -d ':' -f 3)
subid=65536
#TO DO improve this part
if [ $user_entry -lt $subid ]; then
   echo "/etc/subuid should contain more than 65536 sub-IDs"
   exit 1
fi
if [ $group_entry -lt $subid ]; then
   echo "/etc/subgid should contain more than 65536 sub-IDs"
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

sudo mkdir -p /etc/systemd/system/user@.service.d
sudo tee /etc/systemd/system/user@.service.d/delegate.conf> /dev/null << EOF
[Service]
Delegate=yes
EOF
echo "The system is going to reboot now"
#sudo reboot


