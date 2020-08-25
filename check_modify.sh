#!/bin/bash
#author: QingFeng
#qq: 530035210
#blog: http://my.oschina.net/pwd/blog
#自动检测文件的最新更新时间,经过N分钟后,如果没变化就重启服务
#缺省的配置如下

logdir=/var/log/check         #日志路径
log=$logdir/check.log            #日志文件
is_font=1                #终端是否打印日志: 1打印 0不打印
is_log=1                 #是否记录日志: 1记录 0不记录
restart_file=/root/run.sh  #服务启动和关闭控制脚本
end_string="所有导数已经结束"   #监控文件结束标识

#动态数据时间
datef(){
date "+%Y-%m-%d %H:%M:%S"
}

#动态打印日志
print_log(){
if [[ $is_log -eq 1  ]];then
[[ -d $logdir ]] || mkdir -p $logdir
echo "[ $(datef) ] $1" >> $log
fi
if [[ $is_font -eq 1  ]];then
echo "[ $(datef) ] $1"
fi
}

#检查目录
check_dir(){
if [[ ! -d $basedir  ]];then
print_log "目录不存在: $basedir"
exit
fi
}

#检查文件
check_file(){
if [[ ! -f $firt_args  ]];then
print_log "文件不存在: $firt_args"
exit
fi
}

#监控文件&restart
monitor_file(){
content=$(grep "$end_string" $firt_args)
if [[  -z $content  ]];then
print_log ""
print_log "没有找到结束标识,开始监控文件"
print_log  "开始检测文件更改时间."
utc_time=$(stat $firt_args |grep "Modify"  |awk -F'Modify:' '{print $2}')
microtime=$(date -d "$utc_time" +%s)
print_log  "等待$second秒..."
sleep $second
utc_time2=$(stat $firt_args |grep "Modify"  |awk -F'Modify:' '{print $2}')
microtime2=$(date -d "$utc_time2" +%s)
if [[  $microtime != $microtime2   ]];then
print_log   "文件:$firt_args ------$second秒后发生了变化->退出操作"
exit
fi
if [[ ! -f $restart_file  ]];then
print_log  "服务控制脚本不存在:$restart_file "
exit
fi
print_log  "文件:$firt_args ------$second秒后文件更新时间相等."
print_log  "开始重启."
/bin/bash $restart_file   $third   $fourth $five $six
print_log  "重启完成."

else
print_log "找到结束标识,不需要监控文件."
fi
}


#主函数
run(){
#第一个参数的判断
if [[  "$1" != ""  ]];then
firt_args=$1
check_file
else
echo -e "
 自动检测文件的md5值,经过N秒钟后,如果没变化就重启服务
 用法示例"
echo -e  "
$0:
   /bin/bash $0  要监控的文件   监控的时间(单位:秒)   应用的名称   应用的关键字    '执行启动的命令'     要做的动作
exp:
   /bin/bash $0  "/data/log/policy-root-new-2/policy-root-new-2.\$\(date "+%Y-%m-%d"\).log"  10  policy-root-new-2   policy-root-new-2  '/data/www/apps/policy-root-new-2/bin/boxrun'  restart/stop/start
"
exit
fi


#第二个参数的判断
if [[ $2 != ""  ]];then
second=$2
if [[ $second  -eq 0   ]];then
print_log "第二个参数,不能为0"
exit
fi

else
print_log "第二个参数,不能为空"
exit
fi


#第三个参数的判断
if [[ $3 != ""  ]];then
third=$3
else
print_log  "第三个参数,不能为空"
exit
fi

#第四个参数的判断
if [[ $4 != ""  ]];then
fourth=$4
else
print_log  "第四个参数,不能为空"
exit
fi

if [[ $5 != ""  ]];then
five=$5
else
print_log  "第五个参数,不能为空"
exit
fi

if [[ $6 != ""  ]];then
six=$6
else
print_log  "第六个参数,不能为空"
exit
fi

monitor_file
}

run $1 $2 $3 $4 $5 $6
