#!/bin/bash
sed -rn '/bash$/s/:.*//p' /etc/passwd > name.txt
for i in `cat name.txt`
do
awk -F: '/^'${i}'/{print $1" --> "$2}' /etc/shadow
done
