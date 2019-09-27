#!/bin/bash 
T=$(date "+%Y-%m-%d %H:%M:%S")
before=$(date -d "15 minutes ago" "+%Y-%m-%d %H:%M:%S")
history	| awk '{$1=null;print $0}' > /opt/historylog.txt
sed -en "/${before}/,/${T}/p" /opt/historylog.txt
