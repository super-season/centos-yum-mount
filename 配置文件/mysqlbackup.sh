#!/bin/bash
########################
#备份数据库，并只保留最近的5个文件
########################
t=`date +%m%d%H%M`   #得到时间，用于标记备份文件
#openssl加密后的字符串，解密
#加密语句：
#echo 123456 | openssl aes-128-cbc -k 123 -base64
password=$(echo 'U2FsdGVkX18vH5U3hRMbKc1QpR9pPZQ5C1durJ9+0pA=' | openssl aes-128-cbc -d -k 123 -base64)
#--single-transaction用户备份时不用锁表，开启事务一致性
echo "---------starting time:$(date +'%Y-%m-%d %H:%M:%S')--------" >> /data/mysqlbackup/backup.log
mysqldump -uroot -p"${password}" --single-transaction --all-databases > /data/mysqlbackup/all_backup${t}.sql 
echo "备份文件：/data/mysqlbackup/all_backup${t}.sql" >> /data/mysqlbackup/backup.log
echo "---------finished time:$(date +'%Y-%m-%d %H:%M:%S')--------" >> /data/mysqlbackup/backup.log
echo "####################################################" >> /data/mysqlbackup/backup.log
#ls -t为按时间降序排序，只保留目录下最新的5个文件，其它删除掉，还有日志文件，sed为加绝对路径
ls -t /data/mysqlbackup | sed -r 's#^(.*)#/data/mysqlbackup/\1#g' | awk '{if(NR>6){print $1}}' | xargs rm -f
