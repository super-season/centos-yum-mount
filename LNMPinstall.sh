#!/bin/bash
tar -xf /root/lnmp_soft.tar.gz -C /root
tar -xf /root/lnmp_soft/nginx-1.12.2.tar.gz -C /opt
yum -y install gcc openssl-devel
yum -y install mariadb mariadb-server mariadb-devel
yum -y install php php-mysql php-fpm
systemctl restart mariadb
systemctl restart php-fpm
systemctl enable php-fpm
cd /opt/nginx-1.12.2
 ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
cd /usr/local/nginx
ln -s /usr/local/nginx/sbin/nginx /sbin
nginx
nginx -V

