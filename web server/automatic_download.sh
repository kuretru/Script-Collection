#!/bin/bash
#==================================================
# OS Passed:    CentOS6
# Description:  Web服务器自动下载备份脚本
# Author:       kuretru < kuretru@gmail.com >
# Github:       https://github.com/kuretru/Script-Collection
# Version:      1.0.170205
#==================================================

#下载路径
url='https://lax.i5zhen.com/backup'

#备份路径
backupdic='/data/blog'

today=$(date +%y%m%d)					

#检查目录是否存在，初始化数据
function CheckDic()
{
	url=${url$/}
	backupdic=${backupdic%/}
	if [ ! -d $backupdic ]; then
		echo "备份路径不存在！"
		exit 1
	fi
}

#打包网站数据
function DownloadFile()
{
	cd $backupdic
	wget $url/$today.sql
	wget $url/$today.tar.gz
}

#脚本开始
DownloadFile