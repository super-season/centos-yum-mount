#!/bin/bash
#一个用户文件.一个密码文件,把用户密码改成相应行号的密码
n=0
for i in `cat /opt/0510/user.txt`
do
 let n++
 p=`head -$n /opt/0510/pass.txt | tail -1` #取得相应行号的密码
 echo $p | passwd --stdin $i
done
