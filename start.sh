#!/bin/bash

path=/home/xuan
memory_for_one=8

source ./set.sh

declare -a files
n=0
for i in `ls -d ${path}/es*/`
do
    files[$n]=$i 
    n=`expr $n + 1`
done

echo It has : ${n} es/
#another
#for i in ${!files[*]}
#do 
#    echo $i ${files[i]}
#done

available=`expr $(free -g | awk '{print $7}') / ${memory_for_one} `
#echo $available
for((i=1;i<="$available";i++))
do 
   if [ $i -le $n  ]
   then 
     file="${path}/es${i}/"bin/elasticsearch
     sudo -u elasticsearch  $file -d 
     echo es${i} is started
   fi
done

#info=es1
#sstr=`echo $info | cut -d s -f 2`

