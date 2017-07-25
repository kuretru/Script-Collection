#!/bin/bash
#==================================================
# OS Passed:    CentOS7
# Description:  bash登录时自动发送登录提醒
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.1.170725
#==================================================

#Server酱调用密钥
key='Your key'

user=$(whoami)
hostname=$(hostname | sed 's/\./_/g')
ip=$(strings /var/log/lastlog | grep -o -P "(\d+\.)(\d+\.)(\d+\.)\d+")
now=$(date "+%Y.%m.%d_%H.%M.%S")

wget -q --spider https://sc.ftqq.com/${key}.send?text="${hostname}登录提醒"\&desp="IP地址${ip}，用户名${user}，时间${now}"