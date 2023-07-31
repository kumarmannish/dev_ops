#!/bin/bash

USR='devops'

for host in `cat remote_hosts`
do
   echo
   echo "#########################################################"
   echo "Connecting to $host"
   echo "Pushing Script to $host"
   scp script.sh $USR@$host:/tmp/
   echo "Executing Script on $host"
   ssh $USR@$host sudo /tmp/script.sh
   ssh $USR@$host sudo rm -rf /tmp/script.sh
   echo "#########################################################"
   echo
done 
