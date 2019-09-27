#!/bin/bash
cat /etc/redhat-release
free -h | awk 'BEGIN{print "内存:"}NR!=1{print $1,$2}'
lscpu | grep '^CPU(s)'
df -h
