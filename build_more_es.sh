#!/bin/bash
#set -x

#memory_for_one=8

source ./hpp.sh

datapath=""

if [ $# -lt 2 ]
then 
   echo "You shoule at least enter hostname and the number you wanna more build "
   exit 1
elif [ $# = 3 ]
then 
	memory_for_one=${3}
fi

passwd=""
for group in ${!hosts[@]};
do
  for host in ${hosts[$group]};
    do
      if [ ${1} = ${host} ]
	  then
	    passwd=${all_passwd[$group]}
      fi
    done
done
host=${1}

if [ ${#passwd} = 0 ]
then 
   echo 'No passwd found for host:'${1}
   exit 1
fi 

#$1 is hostname $2 is the number you wanna build more

#向每个host发出查询请求，host有多少个es文件夹

#新的方法尝试实现二维数组，失败
#declare -a all=(shiva perf ceg bai)
#for i in ${all[@]};
#do
#	tmp=($i)
#	for j in ${tmp[@]}
#	do
#		echo $j
#	done
#done

#echo ${1}
exists=`sshpass -p $passwd ssh root@${host} "ls -d ${path}/es*/ 2> /dev/null | wc -l"`
#echo $exists

number_to_build=0
if [ ${2} = 0 ]
then
  memory=$(sshpass -p ${passwd} ssh root@${host} "free -g | awk '{print \$7}'")
  number_to_build=$(expr ${memory} / ${memory_for_one})
else
  number_to_build=${2}
fi
declare -i max=`expr ${number_to_build} + ${exists}`
for((i=`expr $exists + 1`;i<=${max};i++))
do
  dir=${path}/es$i
  echo "tar ......................................................................................................................."
 # sshpass -p $passwd ssh root@${1} "cp -r  ${path}/es1 ${dir}"
 # sshpass -p $passwd ssh root@${1} "chown -R elasticsearch:elasticsearch ${dir}"
  name=$(sshpass -p ${passwd} ssh root@${host} "tar -xzvf ${path}/es.tar.gz -C ${path}/ | head -n 1 | cut -d'/' -f2")
  sshpass -p ${passwd} ssh root@${host} "tar -xzf ${path}/es.tar.gz -C ${path}/ "
  sshpass -p ${passwd} ssh root@${host} "mv ${path}/${name}  ${dir}"
  sshpass -p ${passwd} ssh root@${host} "chown -R elasticsearch:elasticsearch ${dir}"
  echo "Chaning values of elasticsearch.yml"
  datapath=`eval echo '$'"$host"`
  sshpass -p $passwd ssh root@${host} "python ${path}/change.py  ${dir}/config/elasticsearch.yml ${1} ${i} ${datapath}"
  echo "Creating data directory........."
  datapath=${datapath//,/ }
  echo datapath"=" ${datapath}
  sshpass -p $passwd ssh root@${host} "bash ${path}/mkdir_data.sh ${i} \"${datapath}\""
  #fangzhi
  sshpass -p $passwd ssh root@${host} "touch ${path}/set.sh && chmod +x ${path}/set.sh && echo -e path=${path}'\n'memory_for_one=${memory_for_one} > ${path}/set.sh" 
  #sshpass -p 13579Tp, ssh root@shiva01 "touch ${path}/set.sh && chmod +x ${path}/set.sh && echo -e \"path=${path}\nmemory_for_one=${memory_for_one}\" > ${path}/set.sh" works too

done
