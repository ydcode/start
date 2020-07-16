# GCE dev-mode

apt install wget -y
wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -zxvf frp_0.33.0_linux_amd64.tar.gz
rm -rf frp_0.33.0_linux_amd64/frps*

cp frp_0.33.0_linux_amd64/frpc /usr/bin/
