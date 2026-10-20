#!/bin/bash
#
# DIY part 2: feeds 安装后、defconfig 前执行
#

# ===== 主机名：刷好第一次开机就是 xingchen，无需手动改 =====
sed -i "s/hostname='ImmortalWrt'/hostname='xingchen'/g" package/base-files/files/bin/config_generate

# ===== LAN IP =====
# 不需要改：ImmortalWrt 默认就是 192.168.6.1
