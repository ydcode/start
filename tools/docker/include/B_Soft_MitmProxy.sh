Install_MitmProxy()
{
       wget https://snapshots.mitmproxy.org/5.1.1/mitmproxy-5.1.1-linux.tar.gz
       tar -zxvf mitmproxy-*-linux.tar.gz
       sudo mv mitmproxy mitmdump mitmweb /usr/bin
}
