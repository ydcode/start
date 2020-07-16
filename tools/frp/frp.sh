wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -zxvf frp_0.33.0_linux_amd64.tar.gz --strip-components 1

rm -rf frp_0.33.0_linux_amd64.tar.gz && rm -rf frpc*

echo "" > frps.ini
echo "[common]" >> frps.ini
echo "bind_port = 7000" >> frps.ini
echo "vhost_http_port = 80" >> frps.ini


cp frps /usr/bin/


