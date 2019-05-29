#!/bin/bash
#国际象棋棋盘,行和列之和为偶数是蓝色,和为奇数是白色
for i in `seq 1 $1`  #1到$1行
do
    for j in `seq 1 $2` #1到$2列
     do
     sum=$[i+j]
       if [ $[sum%2] -eq 0 ];then
        echo -ne "\033[44m  \033[0m"
       else
        echo -ne "\033[47m  \033[0m"    
       fi
     done
  echo ""   #换行
done
