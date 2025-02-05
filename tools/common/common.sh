#!/bin/bash
# common/common.sh
# 定义通用函数

press_any_key() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
    # 如果 display_menu 在主脚本中定义，这里调用它不会出错，
    # 但请确保主脚本在调用 press_any_key 之前已定义 display_menu。
    display_menu "skip_check"
}
