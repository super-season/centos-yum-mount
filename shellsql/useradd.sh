#!/bin/bash
a=0
b=0
for i in $(cat /opt/0510/user.txt)
 do
  let a++
  b=0
   for j in $(cat /opt/0510/pass.txt)
     do
         let b++
         if  [ $a -eq $b ];then 
           useradd $i
           echo "$j" | passwd --stdin $i
         fi
     done
done

