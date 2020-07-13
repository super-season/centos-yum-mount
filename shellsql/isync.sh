#!/bin/bash
#用inotifywait和rsync远程同步实现两主机文件的实时同步功能
#前提是完成免密远程,用ssh-keygen,ssh-copy-id root@id 两条命令生成私钥和秘钥
from_dir="/var/www/html/"   #需要同步的本机路径,html后面的/表示文件夹的目录
isync="rsync -az --delete $from_dir root@172.25.0.11:/var/www/html" #使用rsync命令同步到远程主机的一个文件夹
while inotifywait -rqq $from_dir  #实时监控本地文件夹有没更改,有更改则这行下面同步步骤
 do
   $isync
 done &
