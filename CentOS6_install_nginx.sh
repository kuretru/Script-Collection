#!/bin/bash
#==================================================
# OS Required:  CentOS6
# Description:  呉真的服务器一键配置脚本安装nginx
# Author:       kuretru < kuretru@gmail.com >
# Github:		https://github.com/kuretru/Script-Collection
# Version:      1.0.170202
#==================================================


#安装ius源
function InstallNginx()
{
	cd /etc/yum.repos.d/
	wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/nginx.repo
}


#脚本开始
clear

cat <<EOF
########################################
#
# 呉真的一键服务器配置脚本，目前只适用于
# CentOS6，从一个新的服务器自动初始化配置
# https://www.i5zhen.com
#
########################################
EOF

read -e -p "输入Y开始安装(y/n)" ANSWER
if [[ "$ANSWER" = 'y' ]] || [[ "$ANSWER" = 'yes' ]]; then
	sleep 1
	
cat <<EOF
########################################
# 安装ius源  
########################################
EOF
	InstallIus
	
	
else
	echo '用户退出'
	exit
fi

