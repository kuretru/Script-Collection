#!/bin/bash
#==================================================
# OS Passed:    CentOS6
# Description:  Web服务器自动备份脚本
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.170204
#==================================================
#注意：请确保用于备份的MySQL用户具有select、lock tables权限
#你可以执行下面的命令新增用户：
#GRANT select,lock tables ON $dbname.* to $mysqluser@'localhost' identified by $mysqlpwd;

#Web目录
webroot='/var/www/blog'			

#MySQL用户名
mysqluser='backup'

#MySQL密码
mysqlpwd='123456'

#MySQL数据库名
dbname='blog'

#备份路径
backupdic='/backup'

today=$(date +%y%m%d)					

#检查目录是否存在，初始化数据
function CheckDic()
{
	webroot=${webroot%/}
	backupdic=${backupdic%/}
	if [ ! -d $webroot ]; then
		echo "网站目录不存在！"
		exit 1
	fi
	if [ ! -d $backupdic ]; then
		echo "备份路径不存在！"
		exit 1
	fi
	if [ ! -f ~/.my.cnf ]; then
		cat <<EOF > ~/.my.cnf
[mysqldump]
user=$mysqluser
password=$mysqlpwd
EOF
	fi
}

#打包网站数据
function PackWebFile()
{
	parent=${webroot%/*}
	child=${webroot##*/}
	cd $parent
	tar -zpcvf $backupdic/$today.tar.gz $child/
}

#备份MySQL
function DumpMySQL()
{
	cd $backupdic
	mysqldump $dbname > $today.sql
}

#脚本开始
CheckDic
PackWebFile
DumpMySQL