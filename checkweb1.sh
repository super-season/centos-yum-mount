#!/bin/bash
cc=b3aa80feb57e8c6b368cc82e14009735
dd=2227bb10fadcf9b800ce62d0f3b869d8
cc1=$(curl -s 192.168.4.13 | md5sum | awk '{print $1}')
dd1=$(curl -s 192.168.4.14 | md5sum | awk '{print $1}')
if [ $cc != $cc1 ];then
  echo "192.168.4.13网页被更改"
else
  echo "192.168.4.13网页没被更改"
fi
if [ $dd != $dd1 ];then
  echo "192.168.4.14网页被更改"
else
  echo "192.168.4.14网页没被更改"
fi
