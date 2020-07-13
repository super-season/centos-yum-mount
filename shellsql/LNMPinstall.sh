#!/bin/bash
#该脚本自动安装LNMP,需要将nginx的安装包放在root目录下
tar -xf /root/lnmp_soft.tar.gz -C /root
tar -xf /root/lnmp_soft/nginx-1.12.2.tar.gz -C /opt #nginx包解压至opt目录
yum -y install gcc openssl-devel
yum -y install mariadb mariadb-server 
yum -y install php php-mysql php-fpm mariadb-devel
systemctl restart mariadb php-fpm
systemctl enable php-fpm mariadb  #mariadb和php-fpm开机自启
cd /opt/nginx-1.12.2
 ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install             #以上为部署lnmp
cd /usr/local/nginx
ln -s /usr/local/nginx/sbin/nginx /sbin
cp /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak
#sed -ri '45s/(index.html)/index.php \1/' /root/nginx.conf
#sed  -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
#sed  -i '69s/^/#/' /usr/local/nginx/conf/nginx.conf
#sed  -ri '70s/(.*)_params/\1.conf/' /usr/local/nginx/conf/nginx.conf #改配置文件
echo 'nginx' >> /etc/rc.local
chmod +x /etc/rc.local  #开机自启
nginx
nginx -V

