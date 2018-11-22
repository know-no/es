#!/bin/bash

source ./hpp.sh

order=""
action=""
if [ $# != 1 ]
then
	echo "You should enter 'start' or 'stop'"
	exit 1
elif [ ${1} = "start" ]
then 
    order=${path}/"start.sh"
	action="start"
elif [ ${1} = "stop" ]
then
	order=${path}/"stop.sh"
	action="stop"
else
    echo "You should enter 'start' or 'stop'"
	exit 1
fi
passwd=""
all=0
for group in ${!hosts[@]}
do
  passwd=${all_passwd[$group]}
  for host in ${hosts[$group]}
    do
      sshpass -p ${passwd} ssh root@${host} "bash $order" | tee ./abcdefg.tmp | more
      
	  tmp=$(cat ./abcdefg.tmp | wc -l)
	  if [ ${action} = 'start' ]
	  then
   	    tmp=`expr ${tmp} - 1`
	  fi
	  all=`expr ${all} + ${tmp} `
	  echo ${host} ${action}ed ${tmp} es_process
#	  ids=`sshpass -p ${passwd} ssh root@${host} "jps | grep Elasticsearch | awk '{ print \$1}'"`
#	  echo "jps":$ids
    done
done

echo -----------------------------------------------------------------------------------------------------------------------------------
echo We totally ${action}ed ${all} es_processes!
