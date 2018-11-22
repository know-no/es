#!/bin/bash

user=elasticsearch
group=elasticsearch

egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then 
    groupadd $group
    echo "正在创建组"
else
	echo "已经有此组"
fi

egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then 
    useradd -g $group $user
    echo "正在创建用户"
else
	echo "已经有此用户"
fi
