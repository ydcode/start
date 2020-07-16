apt install wget -y
wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -zxvf frp_0.33.0_linux_amd64.tar.gz --strip-components 1

rm -rf frp_0.33.0_linux_amd64.tar.gz && rm -rf frpc*

cp frps /usr/bin/

mkdir -p /etc/frp

cat > /etc/frp/frpc.ini<<EOF
[common]
bind_port = 7000
vhost_http_port = 80
EOF
