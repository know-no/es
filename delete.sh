#!/bin/bash


. ./hpp.sh

passwd=""
for group in ${!hosts[@]};
do
  passwd=${all_passwd[${group}]}
  for host in ${hosts[$group]};
    do
      paths=`eval echo '$'"${host}"`
	  paths=${paths//,/" "}
	  echo $paths
      for i in ${paths};
	  do
		sshpass -p ${passwd} ssh -l root ${host} "rm -rf ${i}"
		sshpass -p ${passwd} ssh -l root ${host} "rm -rf ${path}/es*  ${path}/*.sh ${path}/*.py"
    done
	done
done



