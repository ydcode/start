# 备份最新账本
```
先停止Aleo Screen 或者 Docker
apt install -y git wget \
&& cd /root && rm -rf start && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/aleo/ && git fetch --all && git reset --hard origin/master && chmod +x ./ironfish_ledger_backup.sh && ./ironfish_ledger_backup.sh

```
cd /root/start/tools/aleo/ && git fetch --all && git reset --hard origin/master && chmod +x ./ironfish_ledger_backup.sh && ./ironfish_ledger_backup.sh
```
```
恢复账单文件
apt install -y git wget \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/aleo/ && chmod +x ./aleo_ledger_backup.sh && ./aleo_ledger_backup.sh

