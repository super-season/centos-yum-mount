#!/bin/bash
#使用nginx工具
case $1 in
start|1)   #用start或者1就开启
 /usr/local/nginx/sbin/nginx;;
stop|2)
 /usr/local/nginx/sbin/nginx -s stop;;
restart|3)
 /usr/local/nginx/sbin/nginx -s stop
 /usr/local/nginx/sbin/nginx;;
status|4)
 netstat -ntulp | grep nginx
 [ $? -eq 0 ] && echo " nginx启动了" || echo " nginx没启动";;
*)
  echo "please input:start(1)|stop(2)|restart(3)|status(4)";;
esac
