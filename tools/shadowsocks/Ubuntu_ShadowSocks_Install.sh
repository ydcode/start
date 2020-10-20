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

    Echo_Yellow "Shadowsocks Installing....."

    apt-get update
    apt-get install python-pip
    pip install git+https://github.com/shadowsocks/shadowsocks.git@master

    read -p "Set Shadowsocks Password: " ShadowsocksPassword

    echo "sudo ss-server -p 443 -k ${ShadowsocksPassword} -m chacha20-ietf-poly1305" -f ss-server.pid >> ~/.bashrc

    cat ~/.bashrc
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


