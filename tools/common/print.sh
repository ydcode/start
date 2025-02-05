#!/bin/bash

print_red() {
  local text="$1"
  echo -e "\033[31m${text}\033[0m"
}

# 定义绿色打印函数
print_green() {
  local text="$1"
  echo -e "\033[32m${text}\033[0m"
}