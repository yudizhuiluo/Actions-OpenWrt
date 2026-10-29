#!/bin/bash
#
# DIY part 2: feeds 安装后、make defconfig 前执行（工作目录 = openwrt 源码根目录）
# 适用于官方 OpenWrt 24.10 分支（默认主机名 OpenWrt / 默认 IP 192.168.1.1）
#

# ===== 主机名：molinailv（第一次开机即生效）=====
sed -i "s/hostname='OpenWrt'/hostname='molinailv'/g" package/base-files/files/bin/config_generate

# ===== LAN IP：192.168.1.1 → 192.168.2.1 =====
sed -i "s/192.168.1.1/192.168.2.1/g" package/base-files/files/bin/config_generate

# ===== 默认主题设为 Design =====
# (1) luci 集合默认依赖的 bootstrap 换成 design
for f in feeds/luci/collections/luci-light/Makefile feeds/luci/collections/luci/Makefile; do
    [ -f "$f" ] && sed -i 's/luci-theme-bootstrap/luci-theme-design/g' "$f"
done
# (2) luci-base 出厂配置里的 mediaurlbase 改成 design
sed -i 's#/luci-static/bootstrap#/luci-static/design#g' feeds/luci/modules/luci-base/root/etc/config/luci

# ===== UA2F：开启内核 CONNMARK 支持（官方 24.10 默认关闭该选项）=====
sed -i 's/^# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set/CONFIG_NETFILTER_NETLINK_GLUE_CT=y/' target/linux/generic/config-6.6

exit 0
