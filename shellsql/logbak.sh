#!/bin/bash
#对nginx的日志每天进行分割备份
date=`date +%Y%m%d`
logpath=/usr/local/nginx/logs
mv $logpath/access.log $logpath/access.${date}.log
mv $logpath/error.log $logpath/error-${date}.log
kill -USR 1 $(cat $logpath/nginx.pid)
