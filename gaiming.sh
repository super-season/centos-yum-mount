#!/bin/bash
#该程序用户批量更改文件后缀名,如.txt,.con,.repo等
touch /opt/{1..10}.$1
for i in `ls /opt/*.$1`  #得到的文件格式都是:/opt/1.txt......
do
  echo $i
  m=${i%.$1}  #去尾,把.和后缀名去掉,结果给变量m
  mv $i $m.$2  #把文件改名为名字+.新尾缀
done
ls /opt/*.$2   #查看结果
