#!/bin/bash
#
# DIY part 1: feeds 更新前执行（执行时工作目录 = openwrt 源码根目录）
# 只追加源码里没有的 feed / 补装第三方包，重复执行也安全。
# 适用于官方 OpenWrt 24.10 分支。
#

# ===== 1) 小猫咪 OpenClash（feed；Makefile 在子目录 luci-app-openclash/，扫描正常）=====
if ! grep -q 'src-git openclash' feeds.conf.default; then
    echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >> feeds.conf.default
fi

# ===== 2) UA2F（feed；Makefile 在子目录 openwrt/，扫描正常）=====
if ! grep -q 'src-git ua2f' feeds.conf.default; then
    echo 'src-git ua2f https://github.com/Zxilly/UA2F.git' >> feeds.conf.default
fi

# ===== 3) Design 主题：不用 feed，直接克隆进 package/ =====
# 为什么：design 仓库的 Makefile 在仓库根目录，且结尾有签名注释
#   "# call BuildPackage - OpenWrt buildroot signature"，
# scan.mk 建 feed 索引时 grep 会命中这行注释，而 sed 只剥得掉子目录路径、
# 剥不掉根目录路径，于是生成带空格+内容的脏条目，报
#   "target pattern contains no '%'" / "grep: feeds/design/Makefile:# ..."。
# 克隆进 package/luci-theme-design/ 后 Makefile 处于子层，扫描路径剥离正常，
# 与 luci.mk 的 PKG_NAME=$(notdir $(CURDIR)) 机制完全兼容（包名仍是 luci-theme-design）。
if [ ! -d package/luci-theme-design/.git ]; then
    git clone --depth 1 -b js https://github.com/0x676e67/luci-theme-design.git package/luci-theme-design
fi

# ===== 4) Design Config：同上原因，克隆进 package/ =====
if [ ! -d package/luci-app-design-config/.git ]; then
    git clone --depth 1 https://github.com/0x676e67/luci-app-design-config.git package/luci-app-design-config
fi

exit 0
