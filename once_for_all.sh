#!/bin/bash


source ./hpp.sh

for group in ${!hosts[@]};
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[$group]};
    do 
	  echo ${host} : $passwd
	done
done

fuck(){
  h=${1}
  p=${2}
#  echo ${path}
#  ip_addr=`grep ${h} /etc/hosts | awk '{print $1}'`
#  h=${ip_addr}
#  echo ${h}
  num=`sshpass -p ${p} ssh root@${h}  "ls ${path}/es*/ -d 2> /dev/null | wc -l"`
#  echo $num
#  echo $?
  if [ $num = 0 ]
  then
    echo "No es/ in host:${h}"
  fi
  for((i=1;i<="${num}";i++))
  do
    tmp_port=$(sshpass -p ${p} ssh root@${h} "grep transport.tcp.port $path/es${i}/config/elasticsearch.yml | awk '{print \$2}'")
    tmp_host=$(sshpass -p ${p} ssh root@${h} "grep ^network.publish_host $path/es${i}/config/elasticsearch.yml | awk '{print \$2}'")
    unset couple
   	couple=${tmp_host}:${tmp_port}","
    content=${content}${couple}
  done
}


fill_in(){
  h=${1}
  p=${2}
  num=`sshpass -p ${p} ssh root@${h}  "ls ${path}/es*/ -d 2> /dev/null | wc -l"`
  if [ $num = 0 ]
  then
	echo "No es/ in host:${h}"
  fi
  for((i=1;i<=${num};i++))
  do
    sshpass -p ${p} ssh root@${h} "sed -i '/discovery.zen.ping.unicast.hosts: /d' $path/es${i}/config/elasticsearch.yml"
    sshpass -p ${p} ssh root@${h} "echo $content >> $path/es${i}/config/elasticsearch.yml"
  done
}





content="discovery.zen.ping.unicast.hosts: " 
for group in ${!hosts[@]};
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[$group]};
    do
      fuck ${host} ${passwd}
    done
done

content=${content%,}
echo $content


for group in ${!hosts[@]};
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[$group]};
    do
      fill_in ${host} ${passwd}
    done
done
