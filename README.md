
直接在线编辑即可

记得将该 setting.xml 拷贝到.m2目录

```
yum install -y git wget && cd /root && git clone https://github.com/ydcode/start.git && cd start 
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
