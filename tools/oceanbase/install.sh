#!/bin/bash

print_red() {
  local text="$1"
  echo -e "\033[31m${text}\033[0m"
}

print_green() {
  local text="$1"
  echo -e "\033[32m${text}\033[0m"
}

ENABLE_WLAN() {
  ip link delete myvlan4000 2>/dev/null || true; ip link add link enp6s0 name myvlan4000 type vlan id 4000
  ip link set myvlan4000 mtu 1400; ip link set myvlan4000 up; ip addr add 192.168.100.1/24 dev myvlan4000; ip addr show dev myvlan4000
}

Install_ESSENTIAL__DEBIAN() {
  apt install -y iputils-clockdiff rpm2cpio alien
}

Install_OBD() {
  apt install -y iputils-clockdiff rpm2cpio alien
}

Install_OBD