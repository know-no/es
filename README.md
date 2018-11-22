# 配置多个es的脚本说明

### sh
1. build_es.sh
3. build_more_es.sh
4. count.sh
12. tcp.sh
5. create_user_for_all.sh
8. once_for_all.sh
9. start_or_stop.sh
5. add_or_remove.sh
6. delete.sh
10. start.sh
11. stop.sh
6. create_user.sh
7. mkdir_data.sh
13. set.sh  

### python2
1. change.py

### config
1. hpp.sh

### 安装包
1. es.tar.gz

## 准备环境

1. 修改hpp.sh以便连接其他主机
  首先在本地的/etc/hosts中添加路由(将xxxxx-perf1 配置别名perf1，因为-不能出像在shell的变量名中)，然后修改hpp.sh中的配置: 主机的hostname，主机的root密码，memory_for_one(希望给一个es多少内存)，放置es文件夹和脚本的路径

  ```
  hosts=("va01 va02 va03 va04" "perf1 perf2 erf4" "bai1 bai2 bai3" "ba4-jekins bai5 bai6 bai7 bai8")
  all_passwd=("13579SX," "CQMYG" "666+666" "12345678")
  path=/home/somewhere
  memory_for_one=20
  va01="/home/somewhere,/home/someplace"
  .............
  .............
  perf1="/home/p1,/home/f1"
  ```
  hosts的值需要以()包裹， 每个host分组在一对""中， 每个分组以空格" "分隔； all_passwd同理，且必须对应hosts的顺序； path的最后不能有 "/"，且不要有其他的有用文件，因为delete.sh脚本会删除path下的所有sh，py，es*的文件，data的路径，如va01的/home/somewhere,下面不要有其他文件，而是这个文件夹专给es放数据，因为delete.sh会删除这个文件夹下的所有文件
 

2. 将需要的脚本和文件传输到服务器
  * 服务器需要的脚本: 序号 10-14 的sh文件,脚本set.sh在/build_es后在服务器生成， 序号 1的python文件, 文件名必须是es.tar.gz的压缩包，解压后只有一个文件夹！
    elasticsearch-x.x.x/

    ├── bin

    ├── config

    ├── lib

	├── LICENSE.txt

	├── logs

	├── NOTICE.txt

	├── plugins

	└── README.textile

    ```
    
    bash tcp.sh start.sh stop.sh create_user.sh mkdir_data.sh
    ```
    tcp.sh会传输文件到服务器的path中, 若path不存在自动创建
  * 为服务器创建elasticsearch用户
    ```
    bash create_user_for_all.sh
    ```
    有几台服务器，有elasticsearch的用户和组，su elasticsearch却失败，找不到此用户，在服务器运行，usermod -s /bin/bash elasticsearch ，随后可以运行su，不知如果不运行usermod的命令，对启动es的命令 sudo -u elasticsearch  ${elaticsearch_path}/elasticsearch -d 命令是否有影响
  * JAVA_HOME在/usr/java/ ， 如/usr/java/java1.7.0.17 ，终端输入java有显示

## 安装
1.  根据需要的节点数启动脚本: build_es.sh
  build_es.sh会调用本地的 build_more_es.sh ，build_more_es.sh 会调用服务器端的 change.py，mkdir_data.sh ，并且根据hpp.sh在服务器生成文件set.sh; 
  ```
    memory_for_one=xx
    path=/home/somewhere/xxxx
  ```
  * 如果需要根据每台服务器的内存量自动配置, 修改hpp.sh 中的memory_for_one大小，即给一个es进程的内存估计量，运行:
    ```
    bash build_es.sh 
    ```
  * 为每台服务器配置固定数量，运行:
    ```
    bash build_es.sh 数量
    ```
  此时，每个es*/config/elasticsearch.yml 中除了 discovery的host:port都已经写好了

2. 给所有es添加discovery的值，运行脚本: bash once_for_all.sh

## 启动和关闭
  start_or_stop 脚本需要输入参数 start 或者 stop ，启动的es进程数量是按照当时服务器的availale内存设置的， available_memory / memory_for_one ，若要修改这个启动的memory_for_one, 需要修改set.sh中的值,然后运行 ./tcp.sh start.sh  ，将脚本送到服务器。当在集群运行时, 不能使用start_or_stop.sh 和 start.sh 去启动新的进程， 须手动启动或运行停止脚本后再开启

 
## 修改
  * 增加es文件夹，运行 build_more_es.sh 后面加参数 hostname  和  数量，当数量为0，则根据内存量和hpp.sh 中的memory_for_one 设置数量 。然后不能忘记运行: once_for_all.sh  
  * 为配置文件elasticsearch.yml 添加或者修改配置 ，运行
    ```    
    bash add_or_remove.sh  属性  [值]
    ```
    若参数只有属性，那么删除此属性， 既有属性又有值，当属性存在于配置文件中，修改，不然增加

## 统计
  count.sh 统计每个服务器运行着的es 进程，一共运行着多少es进程，另外有一个统计值:we can start * es_process 只有在没有es进程运行时才具有参考意义

## 删除
  脚本delete.sh读取hpp.sh的path 以及 各host的data路径，全部删除
