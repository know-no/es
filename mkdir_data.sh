#!/bin/bash
#$1=num是第几个进程
#$2 是存储的paths
num=$1
echo "We are serving for es: "$num
paths=$2


for i in ${paths[@]};
do
  dir=${i}/${num}/search/data
  if [ -e ${dir} ]
  then
    echo "${dir} already exist"
    chown -R elasticsearch:elasticsearch ${dir}
  else
#    echo "Making dirs ${dirs[$i]}......"
    mkdir -p ${dir}
    echo "dirs ${dir} made......"
    chown -R elasticsearch:elasticsearch ${dir}
  fi
done
