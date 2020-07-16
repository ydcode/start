wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -zxvf frp_0.33.0_linux_amd64.tar.gz --strip-components 1

rm -rf frp_0.33.0_linux_amd64.tar.gz && rm -rf frpc*


cat > /etc/frp/frpc.ini<<EOF
[common]
bind_port = 7000
vhost_http_port = 80
EOF


cat > /etc/systemd/system/frpc.service<<EOF
[Unit]
Description=frpc daemon
After=syslog.target  network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/frp/frpc -c /etc/frp/frpc.ini
Restart= always
RestartSec=1min
ExecStop=/usr/bin/killall frpc


[Install]
WantedBy=multi-user.target
EOF
