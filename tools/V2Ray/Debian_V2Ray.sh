#!/bin/bash



Install_V2Ray()
{

    Echo_Yellow "V2Ray Installing....."

    sudo apt update
    
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    systemctl enable v2ray
    systemctl start v2ray


    mkdir /etc/v2ray && cd /etc/v2ray 
    wget https://raw.githubusercontent.com/ydcode/start/master/tools/V2Ray/config.json
    
    vi config.json
    service v2ray restart
}




