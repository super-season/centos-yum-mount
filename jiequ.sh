#!/bin/bash
pass1=
x=abcdefghijklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ0123456789
for i in {1..8}
do
  s=$[RANDOM%62] #或者用${#x}也能得到x的位数
  pass=${x:s:1}  #从x变量中随机截取1个字符,s是截取第s+1位置的字符(字符从0开始算),1代表1位
  pass1=${pass1}$pass #pass1+=$pass
done
echo $pass1   #随机8位字符

