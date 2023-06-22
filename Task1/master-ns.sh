#!/bin/bash 

unshare -p -u -n --fork --mount-proc sleep infinity 1 &
wait
master=$(pgrep -fn "sleep infinity 1") 
nsenter -u -t $master hostname master

ip link add veth0 type veth peer name veth1
ip link set veth1 netns $master 


nsenter -n -u -p -m -t $master bash 
 
 

 
 
