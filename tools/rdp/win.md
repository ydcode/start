
```
apt update && apt install -y qemu-kvm && [ ! -f /tmp/win.iso ] && wget -O /tmp/win.iso https://mirror.hetzner.de/bootimages/windows/SW_DVD9_Win_Server_STD_CORE_2022_2108.15_64Bit_English_DC_STD_MLF_X23-31801.ISO
qemu-system-x86_64 -net nic -net user,hostfwd=tcp::3389-:3389 -m 2048M -enable-kvm -cpu host,+nx -M pc -smp 2 -vga std -usbdevice tablet -k fr -cdrom /tmp/win.iso -drive file=/dev/nvme0n1,format=raw -boot once=d -vnc :1
```

```

#VNC:1  可能会导致设置密码的文本不一致，需要注意  输入:qq123$  得到:aa123$
#Local Server --> Enable Remote Desktop


#安装完成后，关闭qemu

#2.更改端口 --> 重启
$portvalue = 26888
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber" -Value $portvalue
New-NetFirewallRule -DisplayName 'RDPPORTLatest-TCP-In' -Profile 'Public' -Direction Inbound -Action Allow -Protocol TCP -LocalPort $portvalue 
New-NetFirewallRule -DisplayName 'RDPPORTLatest-UDP-In' -Profile 'Public' -Direction Inbound -Action Allow -Protocol UDP -LocalPort $portvalue

Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber"

# 添加IP白名单
$WHITE_IP = 1.1.1.1
New-NetFirewallRule -DisplayName "Allow RDP from 47.242.229.131" -Direction Inbound -Protocol TCP -LocalPort 26888 -RemoteAddress $WHITE_IP -Action Allow

清除其他的通配的放行规则



1.更新系统
0.更改密码

防火墙只允许白名单IP访问
两步验证

禁用 RDP 的多用户会话
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fSingleSessionPerUser" -Value 1




#清理磁盘 blkdiscard -f /dev/nvme0n1 && blkdiscard -f /dev/nvme1n1
#确认 lsblk





```
