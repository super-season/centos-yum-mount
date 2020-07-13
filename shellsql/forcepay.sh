#!/bin/bash
echo "------------start----------------"
forcepath=/home/liuzhaochen/forcepaywar
cd $forcepath
file=`ls -tr | tail -n 1`                         #获取最新上传的文件名
file2=`echo $file | sed -nr 's/(.*)\.war/\1/p'`   #去掉后缀名
rm -rf /home/liuzhaochen/apache-tomcat-8.5.43/webapps/forcepay_war*   #删除旧的解压文件
cp -a ${forcepath}/$file /home/liuzhaochen/apache-tomcat-8.5.43/webapps/ #把新文件放在特定位置
/home/liuzhaochen/apache-tomcat-8.5.43/bin/startup.sh                   #启动tomcat，解压war包
sleep 5
kill -9 `ps -aux | grep '\/liuzhaochen\/apache-tomcat-8.5.43' | awk '{print $2}'`
#/home/liuzhaochen/apache-tomcat-8.5.43/bin/shutdown.sh                #关闭tomcat
T=`date "+%m%d%H%M"`
cp -ra /home/wwwforcepay/forcepay /home/wwwforcepay/forcepay$T         #备份
pid=`ps -aux | grep '\/local\/apache-tomcat*' | awk '{print $2}'`
kill -9 $pid                                                          #停掉生产环境
rm -rf /home/wwwforcepay/forcepay/*                                   #删除旧版本文件
cp -ra /home/liuzhaochen/apache-tomcat-8.5.43/webapps/${file2}/* /home/wwwforcepay/forcepay/
/usr/local/apache-tomcat/apache-tomcat-8.5.43/bin/startup.sh
echo "-------------end----------------"
