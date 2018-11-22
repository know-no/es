#!/bin/bash


memory_for_one=8
source ./hpp.sh

sleep_num=0
avail_num=0
already_num=0
#set -x
for group in ${!hosts[@]};
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[$group]};
    do
      sleep_tmp=`sshpass -p ${passwd} ssh root@${host} "ls -d ${path}/es*/ 2> /dev/null | wc -l"`
	  avail_tmp=$(sshpass -p ${passwd} ssh root@${host} "free -g | awk '{print \$7}'")
#	  echo "ok1"
      already_tmp=$(sshpass -p ${passwd} ssh root@${host} "jps | grep Elasticsearch | wc -l")
#      echo $avail_tmp
	  declare -i avail_tmp=`expr $avail_tmp / ${memory_for_one}`
	  echo we can start ${avail_tmp} es_process in ${host}
	  echo we already hava ${already_tmp} instances in ${host}
	  sleep_num=`expr $sleep_tmp + $sleep_num`
      avail_num=`expr $avail_tmp + $avail_num`
	  already_num=`expr $already_tmp + $already_num`
    done
done
echo there is : $sleep_num "/es"
echo we can start :$avail_num process
echo we already have:$already_num instances
