#!/bin/bash

###################
#开启hadoop集群   #
###################

ss -auntlp | grep 3306 > /dev/null  #判断Mysql有没开启，$?为0则启动了，非0则表示没启动
if [ $? -ne 0 ];then
        /usr/local/mysql/bin/mysqld_safe --user=root &
        echo "Mysql start successed"
else    
        echo "Mysql hased been started"
fi
#---------------------------------------
jps | grep NameNode > /dev/null #判断hdfs有没开启
if [ $? -ne 0 ];then
	/opt/hadoop-2.6.0-cdh5.9.1/sbin/start-dfs.sh    #开启hdfs
        echo "start start successed"
else 
	echo "hdfs hased been started"
fi
#---------------------------------------
jps | grep Manager > /dev/null #判断yarn有没开启
if [ $? -ne 0 ];then
        /opt/hadoop-2.6.0-cdh5.9.1/sbin/start-yarn.sh   #开启yarn
        echo "start start successed"
else
        echo "yarn hased been started"
fi
#---------------------------------------
jps | grep QuorumPeerMain > /dev/null #判断zookeeper有没开启
if [ $? -ne 0 ];then
        /opt/zookeeper-3.4.5-cdh5.9.1/sbin/zkServer.sh start  #开启zookeeper
        echo "zookeeper start successd"
else
        echo "zookeeper hased been started"
fi
#---------------------------------------
jps | grep HMaster > /dev/null   #判断hbase有没开启
if [ $? -ne 0 ];then
        /opt/hbase-1.2.0-cdh5.9.1/bin/start-hbase.sh     #开启hbase
        echo "hbase start successed"
else
        echo "hbase hased been started"
fi
#---------------------------------------
ss -auntlp | grep 10000 > /dev/null  #判断hiveserver2有没开启
if [ $? -ne 0 ];then
        nohup hive --service metastore &  #开启hive元数据任务
	nohup hive --service hiveserver2 &  #开启10000端口让第三方软件连接
        echo "hiveserver2 start successed"
else
        echo "hiveserver2 hased been started"
fi
