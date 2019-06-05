#!/bin/bash
awk -F: '/bash$/{print $1}' /etc/passwd > /opt/0514/user.txt
for name in `cat /opt/0514/user.txt`
do
 grep "^${name}:" /etc/shadow | awk -F: '{print $1" --> "$2}' >> /opt/0514/pass.txt
done
