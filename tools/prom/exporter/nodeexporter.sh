groupadd prometheus
useradd -g prometheus -d /var/lib/prometheus -s /sbin/nologin prometheus

wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
tar -zxvf node_exporter-0.15.2.linux-amd64.tar.gz

mkdir -p /usr/local/prometheus/node_exporter

mv node_exporter-0.15.2.linux-amd64/* /usr/local/prometheus/node_exporter/

cp -f /root/start/tools/prom/exporter/node_exporter.service /usr/lib/systemd/system/node_exporter.service

systemctl enable node_exporter
systemctl start node_exporter

#不要更改Node Exporter版本，新版更改，dashboard不兼容   Dashboard编号22
#需要开启端口
#Grafana Master Server也要开启端口
# systemctl --no-pager -l status node_exporter

# firewall-cmd --permanent source address="127.0.0.3" port protocol="tcp" port="1521" accept"
# firewall-cmd --zone=public --add-port=9100/tcp --permanent
# firewall-cmd --zone=public --remove-port=9100/tcp --permanent



# firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="10.9.96.5" port protocol="tcp" port="9100" accept"
# sudo firewall-cmd --reload
# firewall-cmd --list-all

# ip a | grep 10.

