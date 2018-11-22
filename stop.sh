#！/bin/bash


ids=$(jps | grep Elasticsearch | awk '{ print $1}')

for i in ${ids[*]}
do
 echo killing $i ...
 kill -9 $i
 
done

