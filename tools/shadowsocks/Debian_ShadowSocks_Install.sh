#!/bin/bash


Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}


Install_Shadowsocks()
{
    if [ -e "/usr/bin/ssserver" ] || [ -e "/usr/local/bin/ssserver" ]; then #已安装
        Echo_Green "Shadowsocks Server already installed."
        cat /etc/profile
    else

    Echo_Yellow "Shadowsocks Installing....."

    apt-get install python-pip
    pip install git+https://github.com/shadowsocks/shadowsocks.git@master

    read -p "Set Shadowsocks Password: " ShadowsocksPassword

    ssserver -s ${IP} -k ${ShadowsocksPassword} -d start
    
		if grep -q "ssserver" "/etc/profile"; then #条目已存在
			  Echo_Green "/etc/profile  Shadowsocks Exist."
		else
			echo "sudo ssserver -p 666 -k ${ShadowsocksPassword} -m rc4-md5 --user nobody -d start" >> /etc/profile
			source /etc/profile
		fi
    
		Echo_Green "New Install_____Shadowsocks Server IP: ${IP}   Password: ${ShadowsocksPassword}"
		
		cat /etc/profile
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
