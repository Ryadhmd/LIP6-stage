#!/bin/bash 

unshare -p -u -n --fork --mount-proc sleep infinity 1 & 
sleep 1
master=$(pgrep -fn "sleep infinity 1") 
nsenter -u -t $master hostname master

ip link add veth0 type veth peer name veth1
ip link set veth1 netns $master 

nsenter -n -u -p -m -t $master bash 
 
Ip link set up veth1
Ip addr add 192.168.1.2/24 dev veth1
Ip route add default via 192.168.1.254 


 
 
