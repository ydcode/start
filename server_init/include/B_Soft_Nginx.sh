#!/bin/bash

Upgrade_Nginx()
{
    yum install -y gcc-c++ pcre-devel zlib-devel make unzip

    cd ${CurrentDir}
    NPS_VERSION="1.12.34.2"
    wget https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}-beta.zip
    unzip v${NPS_VERSION}-beta.zip
    cd ngx_pagespeed-${NPS_VERSION}-beta/
    psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
    [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
    wget ${psol_url}
    tar -xzvf $(basename ${psol_url})  # extracts to psol/


    Cur_Nginx_Version=`/usr/local/nginx/sbin/nginx -v 2>&1 | cut -c22-`

    if [ -s /usr/local/include/jemalloc/jemalloc.h ] && /usr/local/nginx/sbin/nginx -V 2>&1|grep -Eqi 'ljemalloc'; then
        NginxMAOpt="--with-ld-opt='-ljemalloc'"
    elif [ -s /usr/local/include/gperftools/tcmalloc.h ] && grep -Eqi "google_perftools_profiles" /usr/local/nginx/conf/nginx.conf; then
        NginxMAOpt='--with-google_perftools_module'
    else
        NginxMAOpt=""
    fi

    Nginx_Version="1.12.0"
    echo "Current Nginx Version:${Cur_Nginx_Version}"
    echo "+---------------------------------------------------------+"
    echo "|    You will upgrade nginx version to ${Nginx_Version}"
    echo "+---------------------------------------------------------+"

    get_char

    echo "============================check files=================================="
    cd ${CurrentDir}
    if [ -s nginx-${Nginx_Version}.tar.gz ]; then
        echo "nginx-${Nginx_Version}.tar.gz [found]"
    else
        echo "Notice: nginx-${Nginx_Version}.tar.gz not found!!!download now......"
        wget -c --progress=bar:force http://nginx.org/download/nginx-${Nginx_Version}.tar.gz
        if [ $? -eq 0 ]; then
            echo "Download nginx-${Nginx_Version}.tar.gz successfully!"
        else
            echo "You enter Nginx Version was:"${Nginx_Version}
            Echo_Red "Error! You entered a wrong version number, please check!"
            sleep 5
            exit 1
        fi
    fi
    echo "============================check files=================================="

    Tar_Cd nginx-${Nginx_Version}.tar.gz nginx-${Nginx_Version}
    ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-ipv6 --with-http_sub_module --add-module=${CurrentDir}/ngx_pagespeed-${NPS_VERSION}-beta ${PS_NGX_EXTRA_FLAGS} ${NginxMAOpt} ${Nginx_Modules_Options}
    make

    rm -rf /usr/local/nginx/sbin/nginx
    \cp objs/nginx /usr/local/nginx/sbin/nginx
    echo "Test nginx configure file..."
    /usr/local/nginx/sbin/nginx -t
    echo "upgrade..."
    make upgrade

    cd ${CurrentDir}

    if [ ! -d "/home/ngx_pagespeed_cache" ]; then
        mkdir /home/ngx_pagespeed_cache
    fi

    Echo_Green "======== upgrade nginx completed ======"
    echo "Program will display Nginx Version......"
    /usr/local/nginx/sbin/nginx -v
}


	
Nginx_Choice()
{
	NginxChoice="y"
	Echo_Yellow "----------------------------------------------------"
	Echo_Yellow "Upgrade Nginx ?"


    read -p "Default Yes,Enter your choice [Y/n]: " NginxChoice
	
	case "${NginxChoice}" in
    [yY][eE][sS]|[yY])
        echo "You will Add Nginx"
        NginxChoice="y"
        ;;
    [nN][oO]|[nN])
        echo "No Nginx"
        NginxChoice="n"
        ;;
    *)
        echo "No input,You will add  Nginx"
        NginxChoice="y"
    esac
	
	
	if [ "${NginxChoice}" = "y" ]; then		
		Upgrade_Nginx
    else
		Echo_Yellow "Choose No Nginx"
    fi
	
	
}

Nginx_Choice