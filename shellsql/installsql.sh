#!/bin/bash
if [ $# -eq 3 ];then
 for i in $1 $2 $3
  do
   scp '/linux-soft/03/mysql/mysql-5.7.17.tar' 192.168.4.${i}:/root
   ssh root@192.168.4.${i} "
   LANG=en growpart /dev/vda 1;
   xfs_growfs /dev/vda1;
   mkdir /root/mysql;
   tar -xf /root/mysql-5.7.17.tar -C /root/mysql;
   cd /root/mysql;
   yum -y install mysql-com*;
   systemctl restart mysqld;
   systemctl enable mysqld
    "
  done
else
 echo "IP1 IP2 IP3"
fi
