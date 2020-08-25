#!/bin/sh
ps -fe|grep /usr/sbin/tinyproxy |grep -v grep
if [ $? -ne 0 ]
        then
                /usr/sbin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf
                echo "start process....."
        else
                echo "running....."
fi
