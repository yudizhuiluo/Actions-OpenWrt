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

# ===== 3) Design 主题（包名由目录名决定，feed 名必须与包名一致）=====
# 重要：官方 OpenWrt 是新版 JS LuCI，必须用 js 分支（README 明确支持 21/23/24.x，
#       v7.0 持续维护、修了 OpenClash 兼容 bug）。
#       main 分支（5.8.0）是给 LEDE 的 lua 版 LuCI 用的旧版，24.10 上别用。
if ! grep -q 'src-git luci-theme-design' feeds.conf.default; then
    echo 'src-git luci-theme-design https://github.com/0x676e67/luci-theme-design.git^js' >> feeds.conf.default
fi

# ===== 4) Design Config（Design 主题配套设置页）=====
if ! grep -q 'src-git luci-app-design-config' feeds.conf.default; then
    echo 'src-git luci-app-design-config https://github.com/0x676e67/luci-app-design-config.git' >> feeds.conf.default
fi

exit 0
