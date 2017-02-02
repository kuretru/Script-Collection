#!/bin/bash
#==================================================
# OS Required:  CentOS6
# Description:  呉真的服务器一键配置脚本安装Apache2.4，PHP7.1,配置HTTP2
# Author:       kuretru < kuretru@gmail.com >
# Github:		https://github.com/kuretru/Script-Collection
# Version:      1.0.170131
#==================================================

#OpenSSL下载地址
opensslURL='openssl-1.0.2k.tar.gz'

#Apache2.4下载地址
apacheURL='httpd-2.4.25.tar.gz'

#安装ius源
function InstallIus()
{
	yum -y install https://rhel6.iuscommunity.org/ius-release.rpm
	rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
}

#安装Apache2.4
function InstallApache24()
{
	yum -y install httpd24u nghttp2 httpd24u-devel
}
 
#编译新版OpenSSL
function UpdateOpenSSL()
{
	#编译
	cd /usr/local/src/
	wget "https://www.openssl.org/source/${opensslURL}"
	tar -xzvf $opensslURL
	cd ${opensslURL%.tar.gz}
	./config --prefix=/usr/local/openssl --shared
	make
	make install
	
	#替换旧OpenSSL
	cd /usr/bin/
	mv openssl openssl.OFF
	ln -s /usr/local/openssl/bin/openssl openssl
	cd /usr/include
	mv openssl openssl.OFF
	ln -s /usr/local/openssl/include/openssl openssl
	cd /usr/lib64
	ln -s /usr/local/openssl/lib/libssl.so.1.0.0 libssl.so.1.0.0
	ln -s /usr/local/openssl/lib/libcrypto.so.1.0.0 libcrypto.so.1.0.0
}

#编译mod_ssl
function Installmodssl()
{
	cd /usr/local/src/
	wget "http://mirrors.cnnic.cn/apache/httpd/${apacheURL}"
	tar -xzvf $apacheURL
	cd ${apacheURL%.tar.gz}/modules/ssl
	apxs -i -a -D HAVE_OPENSSL=1 -I/usr/local/openssl/include/openssl/ -L/usr/local/openssl/lib/ -c *.c -lcrypto -lssl -ldl
	cd /etc/httpd/conf.d/
	wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/ssl.conf
}

function InstallPHP71()
{
	yum -y install php71u-fpm-httpd php71u-cli php71u-mysqlnd php71u-json php71u-xml
}

function InstallMySQL57()
{
	yum -y install mysql57u mysql57u-server
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
	
cat <<EOF
########################################
# 安装Apache2.4
########################################
EOF
	InstallApache24
	
cat <<EOF
########################################
# 更新OpenSSL
########################################
EOF
	UpdateOpenSSL
	
cat <<EOF
########################################
# 编译mod_ssl
########################################
EOF
	Installmodssl
	
cat <<EOF
########################################
# 安装PHP7.1
########################################
EOF
	InstallPHP71
	
cat <<EOF
########################################
# 安装MySQL5.7
########################################
EOF
	InstallMySQL57
	
else
	echo '用户退出'
	exit
fi

