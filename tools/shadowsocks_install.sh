#!/bin/bash

Install_Shadowsocks()
{
    if [ -e "/usr/bin/ssserver" ] || [ -e "/usr/local/bin/ssserver" ]; then #已安装
		Echo_Green "Shadowsocks Server already installed."
		cat /etc/profile
	else

      Echo_Yellow "Shadowsocks Installing....."
        yum install -y epel-release
        yum install -y python-pip
        pip install --upgrade pip
        pip install shadowsocks

        read -p "Set Shadowsocks Password: " ShadowsocksPassword

        ssserver -s ${IP} -k ${ShadowsocksPassword} -d start
		if grep -q "ssserver" "/etc/profile"; then #条目已存在
			Echo_Green "/etc/profile  Shadowsocks Exist."
		else
			echo "ssserver -s ${IP} -k ${ShadowsocksPassword} -d restart" >> /etc/profile
			source /etc/profile
		fi
		Echo_Green "New Install_____Shadowsocks Server IP: ${IP}   Password: ${ShadowsocksPassword}"
    fi
}


	
	
Shadowsocks_Choice()
{
	Echo_Yellow "----------------------------------------------------"
	Echo_Yellow "Add Shadowsocks ?"
    read -p "Default No,Enter your choice [y/N]: " ShadowsocksChoice
	
	case "${ShadowsocksChoice}" in
    [yY][eE][sS]|[yY])
        echo "You will Add Shadowsocks"
        ShadowsocksChoice="y"
        ;;
    [nN][oO]|[nN])
        echo "No Shadowsocks"
        ShadowsocksChoice="n"
        ;;
    *)
        echo "No input,No  Shadowsocks"
        ShadowsocksChoice="n"
    esac
	
	
	if [ "${ShadowsocksChoice}" = "y" ]; then		
		Install_Shadowsocks
    else
		Echo_Yellow "Choose No Shadowsocks"
    fi
	
	
}

Shadowsocks_Choice