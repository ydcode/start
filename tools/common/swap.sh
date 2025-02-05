#!/bin/bash

disable_swap() {
  print_red "Swap is enabled, shutting it down..."

#  一起执行 swapoff -a 和 swapon -a 命令是为了刷新 swap，将 swap 里的数据转储回内存，并清空 swap 里的数据。不可省略 swappiness 设置而只执行 swapoff -a；否则，重启后 swap 会再次自动打开，使得操作失效。
#  执行 sysctl -p 命令是为了在不重启的情况下使配置生效。
  grep -q "vm.swappiness = 0" /etc/sysctl.conf || echo "vm.swappiness = 0" >> /etc/sysctl.conf
  swapoff -a && swapon -a
  sysctl -p
  print_green "Swap has been disabled and permanently turned off"
}
