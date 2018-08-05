
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
