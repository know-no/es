#!/bin/bash
#set -x
#declare -a hosts=("va01 va02 va03 va04" "perf1 perf2 perf4" "bas1 bas2 bas3" "bas4 bas5 bas6 bas7 bas8")

source ./hpp.sh

if [ $# = 1 ]
then
	echo "We will delete $1"
elif [ $# = 2 ]
then
	echo "we will add or change $1 as $2"
	echo .............
else
	echo bad args
	exit 1
fi

for group in ${!hosts[*]}
do
	passwd=${all_passwd[${group}]}
	for host in ${hosts[group]}
	do
	  sleep_tmp=`sshpass -p ${passwd} ssh root@${host} "ls -d ${path}/es*/ 2> /dev/null| wc -l"`
	  if [ sleep_tmp = 0 ]
	  then
		echo "No es/ in ${host}"
	  fi
	  for((i=1;i<=${sleep_tmp};i++))
	  do
	    line=0
		if [ $# = 1 ]
		then
         
	      line=`sshpass -p ${passwd} ssh -l root ${host} grep -n ^${1}: ${path}/es${i}/config/elasticsearch.yml | awk 'BEGIN{FS=":"}{print $1}'`
		  sshpass -p ${passwd} ssh -l root ${host} "sed -i '${line}d'  ${path}/es${i}/config/elasticsearch.yml"
        fi
		if [ $# = 2 ]
		  then
	      line=`sshpass -p ${passwd} ssh -l root ${host} grep -n ^${1}: ${path}/es${i}/config/elasticsearch.yml | awk 'BEGIN{FS=":"}{print $1}'`
		  count=`sshpass -p ${passwd} ssh -l root ${host} grep -n ^${1}: ${path}/es${i}/config/elasticsearch.yml | wc -l`
		  if [ $count -gt 0 ]
		  then
			 sshpass -p ${passwd} ssh -l root ${host} "sed -i '${line}d'  ${path}/es${i}/config/elasticsearch.yml"
		     echo Change value on ${host} : es${i} at line ${line}...........
			 ans="${1}: ${2}"
	         sshpass -p ${passwd} ssh -l root ${host} "sed -i '${line}i${ans}' ${path}/es${i}/config/elasticsearch.yml"
	      else
		      echo add value on ${host} : es${i}................
		      ans="${1}: ${2}\n"
		      #echo $ans
		      sshpass -p ${passwd} ssh -l root ${host} "sed -i '\$i${ans}' ${path}/es${i}/config/elasticsearch.yml"
	      fi
        fi
	  done
    done
done
