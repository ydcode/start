#!/bin/bash

config_ulimit__debian() {
  local ulimit_file="/etc/security/limits.d/ulimit.conf"

  if [ -f "$ulimit_file" ]; then
    local soft_limit=$(grep -m1 "soft nofile" $ulimit_file | awk '{ print $4 }')
    echo "File $ulimit_file already exists. No modifications will be made. The current soft ulimit value is $soft_limit."
  else
    echo "root soft nofile 1048576" | sudo tee -a $ulimit_file
    echo "root hard nofile 1048576" | sudo tee -a $ulimit_file
    echo "ulimit has been successfully set and stored in $ulimit_file."
  fi
}

config_ulimit() {
  echo
  echo "⌛️ Starting Config ulimit..."

  config_ulimit__debian

  local ulimit_file="/etc/security/limits.d/ulimit.conf"

  if [ -f "$ulimit_file" ]; then
    echo "✅ Config ulimit successfully: $ulimit_file exists."
    cat "$ulimit_file"
  else
    echo "❌ Config ulimit failed: $ulimit_file does not exist."
    exit 1
  fi
}
