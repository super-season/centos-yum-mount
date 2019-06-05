#!/bin/bash
#统计成功访问该主机网站的ip地址及次数.并进行排序
awk '{ip[$1]++}END{for (i in ip) {print i,ip[i]}}' /var/log/httpd/access_log | sort -n
