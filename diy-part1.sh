#!/bin/bash
#
# DIY part 1: feeds 更新前执行（执行时工作目录 = openwrt 源码根目录）
# 只追加源码里没有的 feed，重复执行也安全。
# 适用于官方 OpenWrt 24.10 分支。
#

# ===== 1) 小猫咪 OpenClash =====
if ! grep -q 'src-git openclash' feeds.conf.default; then
    echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >> feeds.conf.default
fi

# ===== 2) UA2F（校园网防检测，用户态 NFQUEUE，v5.2.0）=====
if ! grep -q 'src-git ua2f' feeds.conf.default; then
    echo 'src-git ua2f https://github.com/Zxilly/UA2F.git' >> feeds.conf.default
fi

# ===== 3) Design 主题 =====
# 重要：feeds.conf 的 feed 名只允许 \w+（字母/数字/下划线），不能带连字符！
#       包名 luci-theme-design 由仓库内 luci.mk 从目录名自动推导，feed 名用 design 即可。
#       官方 OpenWrt 是新版 JS LuCI，必须用 js 分支（README 明确支持 21/23/24.x）。
if ! grep -q 'src-git design ' feeds.conf.default; then
    echo 'src-git design https://github.com/0x676e67/luci-theme-design.git^js' >> feeds.conf.default
fi

# ===== 4) Design Config（Design 主题配套设置页）=====
if ! grep -q 'src-git designconfig' feeds.conf.default; then
    echo 'src-git designconfig https://github.com/0x676e67/luci-app-design-config.git' >> feeds.conf.default
fi

exit 0
