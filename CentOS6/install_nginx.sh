#!/bin/bash
#==================================================
# OS Passed:    CentOS6
# Description:  呉真的服务器一键配置脚本安装nginx，并支持HTTP/2
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.170202
#==================================================

#OpenSSL下载地址
opensslURL='openssl-1.0.2k.tar.gz'

#Nginx1.10下载地址
nginxURL='nginx-1.10.3.tar.gz'

#安装nginx
function InstallNginx()
{
	cd /etc/pki/rpm-gpg/
	wget http://nginx.org/keys/nginx_signing.key
	cd /etc/yum.repos.d/
	wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/files/nginx.repo
	sed -i "s/^gpgcheck=0/gpgcheck=1/g" nginx.repo
	yum -y install nginx
}

#仅下载新版OpenSSL
function DownloadOpenSSL()
{
	cd /usr/local/src/
	wget "https://www.openssl.org/source/${opensslURL}"
	tar -xzvf $opensslURL
}

#编译新版OpenSSL并替换旧版
function UpdateOpenSSL()
{
	#编译
	cd /usr/local/src/${opensslURL%.tar.gz}
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

#编译nginx
function CompileNginx()
{
	yum -y install pcre-devel zlib-devel
	cd /usr/local/src/
	wget "http://nginx.org/download/${nginxURL}"
	tar -xzvf $nginxURL
	cd ${nginxURL%.tar.gz}
	./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
--with-threads \
--with-stream \
--with-stream_ssl_module \
--with-http_slice_module \
--with-mail \
--with-mail_ssl_module \
--with-file-aio \
--with-http_v2_module \
--with-ipv6 \
--with-openssl=/usr/local/src/${opensslURL%.tar.gz}
	make
	service nginx stop
	cd /usr/sbin/
	mv nginx nginx.OFF
	ln -s /usr/local/src/${nginxURL%.tar.gz}/objs/nginx nginx
	service nginx start
}

#安装PHP7.1
function InstallPHP71()
{
	yum -y install php71u-cli php71u-mysqlnd php71u-json php71u-xml
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
# 安装nginx  
########################################
EOF
	InstallNginx
	
cat <<EOF
########################################
# 下载新版OpenSSL
########################################
EOF
	DownloadOpenSSL
	
cat <<EOF
########################################
# 编译nginx，以支持ALPN下HTTP/2
########################################
EOF
	CompileNginx
	
cat <<EOF
########################################
# 安装PHP7.1
########################################
EOF
	InstallPHP71
	
else
	echo '用户退出'
	exit
fi

