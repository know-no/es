#!/bin/bash


source ./hpp.sh
echo ${memory_for_one}

number_to_build=0
if [ $# != 0 ]
then
      number_to_build=${1}
else
	  number_to_build=0
fi


passwd=""
for group in ${!hosts[*]} 
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[${group}]}
  do
	  bash ./build_more_es.sh ${host} ${number_to_build} ${memory_for_one}
  done
done


