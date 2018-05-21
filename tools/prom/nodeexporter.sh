groupadd prometheus
useradd -g prometheus -d /var/lib/prometheus -s /sbin/nologin prometheus

wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz
tar -zxvf node_exporter-0.16.0.linux-amd64.tar.gz

mkdir -p /usr/local/prometheus/node_exporter

mv node_exporter-0.16.0.linux-amd64/* /usr/local/prometheus/node_exporter/

cp -f /root/start/tools/prom/node_exporter.service /usr/lib/systemd/system/node_exporter.service

systemctl enable node_exporter
systemctl start node_exporter
