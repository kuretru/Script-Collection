#!/bin/bash
#==================================================
# OS Passed:    CentOS6
# Description:  bash登录时自动发送登录提醒
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.170501
#==================================================

#Server酱调用密钥
key=''

user=$(whoami)
hostname=$(hostname | sed 's/\./_/g')
ip=$(grep 'Accepted' /var/log/secure | grep ${user} | tail -n 1 |  sed -nr 's/.*[^0-9](([0-9]+\.){3}[0-9]+).*/\1/p')

wget --spider http://sc.ftqq.com/${key}.send?text="${hostname}登录提醒"\&desp="IP地址${ip}，用户名${user}" -q