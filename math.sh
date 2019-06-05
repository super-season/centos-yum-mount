#!/bin/bash
#该程序用作数字的加减乘除取模
if [ $# -eq 0 ];then
 echo '请输入参数,格式: x +|-|\*|/ y' >&2
  exit 1
elif [ "$2" == "+" ];then
  echo "scale=4;$1+$3" | bc
elif [ "$2" == "-" ];then
  echo "scale=4;$1-$3" | bc
elif [ "$2" == "*" ];then
  echo "scale=4;$1*$3" | bc
elif [ "$2" == "/" ];then
  echo "scale=4;$1/$3" | bc
elif [ "$2" == "%" ];then
  echo "scale=4;$1%$3" | bc
else 
  echo '请输入参数,格式: x +|-|\*|/ y' >&2
  exit 2
fi
