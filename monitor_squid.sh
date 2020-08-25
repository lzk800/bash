#!/bin/sh
ps -fe|grep /usr/sbin/squid |grep -v grep
if [ $? -ne 0 ]
        then
                /usr/sbin/squid -f /etc/squid/squid.conf
                echo "start process....."
        else
                echo "running....."
fi
