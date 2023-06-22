#!/bin/bash 

unshare -p -u -n --fork --mount-proc sleep infinity 1 &
master=pgrep -fn "sleep infinity 1" 
nsenter -u -t $master hostname master

nsenter -n -u -p -m -t $master bash 
 
