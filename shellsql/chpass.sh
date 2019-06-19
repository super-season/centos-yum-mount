#!/bin/bashi
#改数据库初始密码
old=$(grep password /var/log/mysqld.log | head -1 | awk '{print $NF}')
echo $old　
#获取数据库初始密码
echo "
validate_password_policy=0
validate_password_length=6
server_id=$i" >> /etc/my.cnf
#更改密码规则
systemctl restart mysqld
mysql -uroot -p"${old}" -e "set password=password("123456");"


