#!/bin/bash
source ./hpp.sh

file_name=" "$*
files=""
for i in ${file_name[@]};
do 
    files=${files}" ./"${i}
done

passwd=""
for group in ${!hosts[@]}
do
  passwd=${all_passwd[$group]}
  for host in ${hosts[$group]}
    do
	  sshpass -p ${passwd} ssh root@${host} "mkdir -p ${path}/ 2> /dev/null"
      sshpass -p ${passwd} scp  ${files} root@${host}:${path}/
#	  for file in ${file_name}
#	  do 
#        scp  ./${file} root@${host}:/home/xuan/
#     ids=`sshpass -p ${passwd} ssh root@${host} "jps | grep Elasticsearch | awk '{ print \$1}'"`
#     echo "jps":$ids
#     done
   done
done
