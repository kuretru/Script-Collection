### CentOS7_setup.sh
安装CentOS7后，一键修改各种配置。
##### 功能
* 更新系统软件包
* 自动安装基本命令
* 配置SSH
* 配置防火墙

##### 使用  
```
wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/CentOS7/CentOS7_setup.sh && chmod u+x CentOS7_setup.sh
修改配置
./CentOS7_setup.sh
```
### install_webserver.sh
CentOS7下，自动安装Apache2.4或Nginx1.13、PHP7.1，启用HTTP/2支持，脚本使用yum安装，减少编译时间。

##### 使用  
```
wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/CentOS7/install_webserver.sh && chmod u+x install_webserver.sh
修改配置
./install_webserver.sh
```
