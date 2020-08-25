#!/bin/sh
ps -fe|grep /usr/sbin/ss5 |grep -v grep
if [ $? -ne 0 ]
        then
                /usr/sbin/ss5 -t -u root -b 0.0.0.0:8080
                echo "start process....."
        else
                echo "running....."
fi
