#!/bin/bash

config_ulimit__debian() {
  ulimit_file="/etc/security/limits.d/ulimit.conf"

  if [ -f "$ulimit_file" ]; then
    soft_limit=$(grep -m1 "soft nofile" $ulimit_file | awk '{ print $4 }')
    echo "File $ulimit_file already exists. No modifications will be made. The current soft ulimit value is $soft_limit."
  else
    echo "root soft nofile 1048576" | sudo tee -a $ulimit_file
    echo "root hard nofile 1048576" | sudo tee -a $ulimit_file
    echo "ulimit has been successfully set and stored in $ulimit_file."
  fi
}

CONFIG2() {
  echo "fs.user-max-processes = 655350" | sudo tee -a /etc/security/limits.conf
  echo "* soft core unlimited" | sudo tee -a /etc/security/limits.conf
  echo "* hard core unlimited" | sudo tee -a /etc/security/limits.conf

  echo "* soft stack unlimited" | sudo tee -a /etc/security/limits.conf
  echo "* hard stack unlimited" | sudo tee -a /etc/security/limits.conf

  echo "fs.aio-max-nr = 1048576" | sudo tee -a /etc/sysctl.conf
  echo "vm.max_map_count = 655360" | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
}

config_ulimit__debian

CONFIG2