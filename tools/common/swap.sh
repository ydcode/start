#!/bin/bash

disable_swap__debian() {
  grep -q "vm.swappiness = 0" /etc/sysctl.conf || echo "vm.swappiness = 0" >> /etc/sysctl.conf
  swapoff -a && swapon -a
  sysctl -p
}

disable_swap() {
  echo
  echo "⌛️ Starting Disable SWAP..."

  disable_swap__debian

  if [ -z "$(swapon --noheadings)" ]; then
    echo "✅ Disable SWAP successfully: no active swap devices found."
  else
    echo "❌ Disable SWAP failed: active swap devices still detected."
    exit 1
  fi
}
