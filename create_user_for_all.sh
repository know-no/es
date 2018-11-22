#!/bin/bash


source ./hpp.sh

passwd=""
for group in ${!hosts[@]};
do
  passwd=${all_passwd[$group]}
  for host in ${hosts[$group]};
    do
	  sshpass -p ${passwd} ssh root@${host} "bash ${path}/create_user.sh"
    done
done
