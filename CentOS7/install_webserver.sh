#!/bin/bash
#==================================================
# OS Passed:    CentOS7
# Description:  呉真的服务器一键安装脚本
#               Apache2.4/Nginx1.13,PHP7.1,支持HTTP/2
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.180106
#==================================================

#安装ius源
function InstallIus()
{
	yum -y install https://centos7.iuscommunity.org/ius-release.rpm
	rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
}

#安装Apache2.4
function InstallApache24()
{
	yum -y install httpd24u nghttp2 httpd24u-devel httpd24u-mod_ssl php71u-fpm-httpd
	systemctl enable httpd.service
	cd /var/www/html
	wget https://raw.githubusercontent.com/kuretru/Script-Collection/master/files/tz.php
}

#安装nginx1.13
function InstallNginx113()
{
	cd /etc/pki/rpm-gpg/
	wget http://nginx.org/keys/nginx_signing.key
	rpm --import /etc/pki/rpm-gpg/nginx_signing.key
	cd /etc/yum.repos.d/
	wget https://raw.githubusercontent.com/kuretru/Script-Collection/master/files/nginx.repo.centos7 -O nginx.repo
	sed -i "s/^gpgcheck=0/gpgcheck=1/g" nginx.repo
	yum -y install nginx php71u-fpm-nginx
	systemctl enable nginx.service
	cd /usr/share/nginx/html
	wget https://raw.githubusercontent.com/kuretru/Script-Collection/master/files/tz.php
}

#安装PHP7.1
function InstallPHP71()
{
	yum -y install php71u-cli php71u-mysqlnd php71u-json php71u-xml
	systemctl enable php-fpm.service
}

#脚本开始
clear

cat <<EOF
########################################
#
# 呉真的一键安装Web服务器脚本，目前只适用于
# CentOS7，从一个新的服务器自动初始化配置
# https://blog.kuretru.com
#
########################################
EOF

read -e -p "输入Y开始安装(y/n)" ANSWER
if [[ "$ANSWER" = 'y' ]] || [[ "$ANSWER" = 'yes' ]]; then
	read -e -p "输入a安装Apache，n安装nginx(a/n)" WEB
	if [[ "$WEB" = 'a' ]] || [[ "$WEB" = 'n' ]]; then
		InstallIus
		if [[ "$WEB" = 'a' ]]; then
			InstallApache24
		else
			InstallNginx113
		fi
		InstallPHP71
	else
		echo '错误的选择'
		exit
	fi
else
	echo '用户退出'
	exit
fi
