#!/bin/bash 
history -w   #保存到家目录的~/.bash_history文件里
T=$(date "+%Y-%m-%d-%H:%M:%S")   #获取当前时间，格式年-月日-时：分：秒
#before=$(date -d "15 minutes ago" "+%Y-%m-%d %H:%M") #得到15分钟前的时间
ls /opt/historylog > /dev/null || mkdir /opt/historylog #如果没有/opt/histtorylog文件就新建一个
history	| awk '{$1=null;print $0}' > /opt/historylog/hisnew.txt #得到最新的一个history命令的文件，存入hisnew.txt文件下
#sed -en "/${before}/,/${T}/p" /opt/historylog.txt   #查找一段时间内的日志，但这段时间没有操作，查找会报错
diff hisold.txt hisnew.txt | awk '{$1=null;print $0}' | grep -v '^$' > history.txt #与15分钟前的命令文件对比，得到一个15分钟内的命令集
unalias cp #取消别名设置，默认cp别名有-i的参数，复制替换要手动确认，取消后就不用手动确认
cp -f  hisnew.txt hisold.txt #强制替换，把新的命令变存入hisold.txt，方便15分钟后对比生成新的命令集
alias cp='cp -i'
#history -w 
#history -c #清空历史记录
