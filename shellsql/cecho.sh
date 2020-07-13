#!/bin/bash
#该程序是输出不同颜色的字体,$1<40是字体颜色,$>40是字体的背景颜色
cecho(){
echo -e "\033[$1m$2\033[0m"     #后面的033[0m是还原当前系统的字体颜色,-e是扩展参数
}
cecho 31 aaaaaa
cecho 32 bbbbbb
cecho 33 cccccc
cecho 34 dddddd
cecho 35 eeeeee
cecho 36 ffffff
