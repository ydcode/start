
直接在线编辑即可

记得将该 setting.xml 拷贝到.m2目录

```
centos + docker bug: 重启无法连接ssh,未排查到具体原因
yum install -y git wget && cd /root && git clone https://github.com/ydcode/start.git && cd start 
```

```
vi ~/.bashrc  添加环境变量
apt install -y git wget sudo && cd /root && git clone https://github.com/ydcode/start.git && cd start 
cd server_init/ && ./install.sh


```

```

php.ini 

cd /home/wwwroot/ && rm -rf latest.zip && wget https://wordpress.org/latest.zip && rm -rf /home/wwwroot/wordpress && unzip latest.zip -d /home/wwwroot/ 
rm -rf www.domain.com/*
mv wordpress/* www.domain.com/

安装插件
Setting Domain 设置 C 
配置Conf(before wordpress conf)

        if ($http_x_request_role != 'cloudfront') {
                return 404;
        }

        sub_filter $server_name $http_x_request_host;
        sub_filter_once off;
        
        
http https模拟访问/admin


安装主题
设置Perlink
```


service network restart

```
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
***********************************************
EOF


cat << EOF > /etc/sysconfig/network-scripts/route-eth0
***********************************************
EOF

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
***********************************************
EOF
```
