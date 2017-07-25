# Script-Collection
呉真自己编写的各种脚本
#### CentOS6
运行在CentOS6下的各种脚本
#### web server  
Web Service相关脚本

### login_notice_for_bash.sh
SSH登录系统后，使用Server酱发送登录提醒。
##### 发送信息
* 登录IP地址
* 登录用户
* 登录时间
* 根据IP识别地理位置(待添加)

##### 使用  
```
echo ". ~/shell/login_notice_for_bash.sh" >> ~/.bash_profile
cd ~/shell
wget https://raw.githubusercontent.com/kuretru/Script-Collection/master/login_notice_for_bash.sh
chmod u+x login_notice_for_bash.sh
sed -i "s/^key='Your key'$/key='在这里写入你的Key'/g" login_notice_for_bash.sh
```
