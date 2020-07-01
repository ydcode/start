Install_Docker_Debian()
{
        apt remove python
        whereis python | xargs rm -rf
        apt autoremove -y
        
        sudo apt-get update -y
        sudo apt-get install -y zlib1g-dev
        wget https://www.python.org/ftp/python/3.7.8/Python-3.7.8.tar.xz
        tar -xf Python-3.?.?.tar.xz
        cd Python-3.*
        ./configure
        sudo make install
        ln -s /usr/local/bin/python3 /usr/bin/python
}
