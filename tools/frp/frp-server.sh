# GCE dev-mode

apt install wget -y
wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -zxvf frp_0.33.0_linux_amd64.tar.gz
rm -rf frp_0.33.0_linux_amd64/frpc*

cp frp_0.33.0_linux_amd64/frps /usr/bin/ && mkdir -p /etc/frp

# if vhost_http_port port < 1024 , remove nobody line
cat > /etc/systemd/system/frps.service<<EOF
[Unit]
Description=Frp Server Service
After=network.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/bin/frps -c /etc/frp/frps.ini

[Install]
WantedBy=multi-user.target
EOF


cat > /etc/frp/frps.ini<<EOF
[common]
bind_port = 7000
vhost_http_port = 80
EOF

systemctl enable frps.service
systemctl start frps.service
systemctl status frps.service


cat /etc/frp/frps.ini
