# 备份最新账本
```
apt install -y git wget \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/aleo/ && chmod +x ./aleo_ledger_backup.sh && ./aleo_ledger_backup.sh

```
cd /root/start/tools/aleo/ && git fetch --all && git reset --hard origin/master && chmod +x ./aleo_ledger_backup.sh && ./aleo_ledger_backup.sh
```