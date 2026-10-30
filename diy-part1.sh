#!/bin/bash
if ! grep -q 'src-git openclash' feeds.conf.default; then
    echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >> feeds.conf.default
fi

if ! grep -q 'src-git ua2f' feeds.conf.default; then
    echo 'src-git ua2f https://github.com/Zxilly/UA2F.git' >> feeds.conf.default
fi

if [ ! -d package/luci-theme-design/.git ]; then
    git clone --depth 1 -b js https://github.com/0x676e67/luci-theme-design.git package/luci-theme-design
fi

if [ ! -d package/luci-app-design-config/.git ]; then
    git clone --depth 1 https://github.com/0x676e67/luci-app-design-config.git package/luci-app-design-config
fi

if [ ! -f package/luci-app-ua2f/Makefile ]; then
    git clone --depth 1 https://github.com/lucikap/luci-app-ua2f.git package/luci-app-ua2f-src
    mv package/luci-app-ua2f-src/luci-app-ua2f package/luci-app-ua2f
    rm -rf package/luci-app-ua2f-src
fi

exit 0
