#!/bin/bash
#此脚本是判断数据磁盘超过85%时通过发送邮件提示自己
used=`df -h | grep '/dev/vda' | awk '{print int($5)}'`
curtime=`date +%F-%T`
if [ "$used" -ge 10 ] ;then
   echo "$curtime
Warning!The disk is used ${used}%"
fi

