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
### install_apache24.sh
CentOS7下，自动安装Apache2.4、PHP7.1、MySQL5.7，更新OpenSSL，启用HTTP/2支持，脚本尽量使用yum安装，减少编译时间。

##### 使用  
```
wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/CentOS7/install_apache24.sh && chmod u+x install_apache24.sh
修改配置
./install_apache24.sh
```
### install_nginx.sh
CentOS7下，自动安装Nginx1.10、PHP7.1，更新OpenSSL，启用ALPN支持，脚本尽量使用yum安装，减少编译时间。

##### 使用  
```
wget https://raw.githubusercontent.com/kuretru/Scrip-Collection/master/CentOS7/install_nginx.sh && chmod u+x install_nginx.sh
修改配置
./install_nginx.sh
```
