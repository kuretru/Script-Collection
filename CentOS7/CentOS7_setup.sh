#!/bin/bash
#==================================================
# OS Required:  CentOS7
# Description:  呉真的服务器一键配置脚本
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.170622
#==================================================

#是否更新内核，不更新改0
UpdateKernel=1			

#修改主机名
HostName='lax.i5zhen.com'

#修改密码
PassWord='123456'

#是否安装ShadowSocks
InstallSS=1

#ShadowSocks密码
SSPassword='123456'

IPv4=$(wget -qO- -t1 -T2 ipv4.icanhazip.com)
IPv6=$(wget -qO- -t1 -T2 ipv6.icanhazip.com)					

#更新软件包
function SystemUpdate()
{
	if [ $UpdateKernel -eq 1 ]; then
		yum -y update
	else
		yum -y --skip-broken --exclude kernel* update
	fi
}

#安装基本软件包
function InstallPackages()
{
	yum -y install vim wget curl tree lsof ntpdate postfix \
epel-release net-snmp bind-utils xz mtr unzip crontabs git make gcc gcc-c++ firewalld
	yum clean all
}

#修改系统基本设置
function SystemConfig()
{
	#修改主机名
	echo "${HostName}" > /etc/hostname
	#修改密码
	echo $PassWord | passwd --stdin root
	#关闭SELinux
	sed -i "s/^SELINUX=.*$/SELINUX=disabled/g" /etc/selinux/config
	setenforce 0
	#配置i18n
	sed -i "s/^LANG=.*$/LANG=\"en_US.UTF-8\"/g" /etc/sysconfig/i18n
	sed -i "s/^SYSFONT=.*$/SYSFONT=\"latarcyrheb-sun16\"/g" /etc/sysconfig/i18n
	#时间相关设置
	/bin/cp -p /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	ntpdate time.windows.com
	systemctl enable crond.service
	echo "0 1 * * * /usr/sbin/ntpdate time.windows.com" > /var/spool/cron/root
	systemctl restart crond.service
	#登录文本
	cat <<EOF > /etc/motd
警告：你的IP已被记录，所有操作将会通告管理员！
Warning: Your IP address has been recorded, all operations will notify the administrator!
EOF
}

#配置SSH
function SSHConfig()
{
	sed -i "s/^.*Port.*$/Port 8022/g" /etc/ssh/sshd_config
	sed -i "s/^#LoginGraceTime/LoginGraceTime/g" /etc/ssh/sshd_config
	sed -i "s/^#MaxAuthTries 6/MaxAuthTries 2/g" /etc/ssh/sshd_config
	sed -i "s/^#PubkeyAuthentication/PubkeyAuthentication/g" /etc/ssh/sshd_config
	sed -i "s/^#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config
	sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
	mkdir /root/.ssh
	touch /root/.ssh/authorized_keys
	cat <<EOF > /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDUnJJ+Yn4dgqtnFKWWvrs1ykceXt3nn9pmi6zFc29QkYjEa99dAeFX3ts2E+e9gswyJIwvh7xqRyfKvii9cAaUpsgX7RkH/qe/fWmSfR3f33CRvdnmwsPI600EBxKKuEzZR3C6EQVtj6Nw7s7DCc46e058nPt/A1fFIavc6EGPGQ==
EOF
	chmod 600 /root/.ssh/authorized_keys
	chmod 700 /root/.ssh
	systemctl restart sshd.service
}

#配置iptables
function iptablesConfig()
{
	systemctl enable firewalld.service
	systemctl start firewalld.service
	firewall-cmd --add-port=8022/tcp --permanent
	firewall-cmd --add-service=http --permanent
	firewall-cmd --add-service=https --permanent
	firewall-cmd --add-port=8023/tcp --permanent
	firewall-cmd --add-port=8023/udp --permanent
	systemctl restart firewalld.service
}

#下载个人配置文件
function DownloadConfig()
{
	cd /root
	wget https://raw.githubusercontent.com/kuretru/Script-Collection/master/files/.vimrc
}

#安装ShadowSocks-libev
function InstallSSlibev()
{
	cd /etc/yum.repos.d
	wget https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo
	yum -y install shadowsocks-libev
	systemctl enable shadowsocks-libev.service
	#开始配置ShadowSocks
	server_value="\"0.0.0.0\""
    if [ ! -z $"IPv6" ]; then
        server_value="[\"[::0]\",\"0.0.0.0\"]"
    fi
    cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":${server_value},
    "server_port":8023,
    "local_port":1080,
    "password":"${SSPassword}",
    "timeout":60,
    "method":"aes-256-cfb"
}
EOF
	sed -i "s/^Group=nogroup/Group=nobody/g" /usr/lib/systemd/system/shadowsocks-libev.service
	systemctl daemon-reload
	systemctl restart shadowsocks-libev.service
}

#脚本开始
clear

cat <<EOF
########################################
#
# 呉真的一键服务器配置脚本，目前只适用于
# CentOS6，从一个新的服务器自动初始化配置
# https://blog.kuretru.com
#
########################################
EOF

read -e -p "输入Y开始安装(y/n)" ANSWER
if [[ "$ANSWER" = 'y' ]] || [[ "$ANSWER" = 'yes' ]]; then
	sleep 1
	
cat <<EOF
########################################
# 开始更新软件包   
########################################
EOF
	SystemUpdate
	
cat <<EOF
########################################
# 开始安装基本工具 
########################################
EOF
	InstallPackages
	
cat <<EOF
########################################
# 开始配置主机设置 
########################################
EOF
	SystemConfig
	
cat <<EOF
########################################
# 配置SSH 
########################################
EOF
	SSHConfig
	
cat <<EOF
########################################
# 配置iptables
########################################
EOF
	iptablesConfig
	
	cat <<EOF
########################################
# 下载个人配置文件
########################################
EOF
	DownloadConfig
	
	if [ $InstallSS -eq 1 ]; then
		cat <<EOF
########################################
# 安装ShadowSocks-libev
########################################
EOF
		InstallSSlibev
	fi
	
else
	echo '用户退出'
	exit
fi

