(function ($) {

    // 修复某些插件导致在https下env(safe-area-inset-bottom)为0的情况
    var url = self.location.href; 
    if ((/(iPhone|iPad|iPod|iOS|Mac|Macintosh)/i.test(navigator.userAgent)) && url.indexOf("openclash") != -1 ) {
        var oMeta = document.createElement('meta');
        oMeta.content = 'width=device-width,initial-scale=1,maximum-scale=1,user-scalable=0,viewport-fit=cover';
        oMeta.name = 'viewport';
        document.getElementsByTagName('head')[0].appendChild(oMeta);
    }

		// 设置indicators图标，(放在menu script执行之前passwall某些代码错误中断导致失败)
		document.getElementById("indicators").addEventListener('DOMSubtreeModified', function () {
			var child = document.getElementById("indicators");
			if (child.firstElementChild.getAttribute("data-indicator") != "uci-changes") {
				child.firstElementChild.textContent = eval("'\ue6b9'")
			}
		}, false);

		// 监听窗口大小，动态设置header box阴影长度
        $(window).resize( function  () {
			if (window.innerWidth <= 992) {
				$("header").css("box-shadow",   "0 2px 4px rgb(0 0 0 / 8%)")
			} else {
				$("header").css("box-shadow",   "17rem 2px 4px rgb(0 0 0 / 8%)")
			}
        });

	// ===== molinailv 定制：Design Config 主题模式强制生效 =====
	// 原版主题深色模式只跟随浏览器/系统偏好（prefers-color-scheme），不读取
	// /etc/config/design 里的 mode。这里读取 uci design.global.mode（Follow System
	// / Force Light / Force Dark），写入 html[data-design-mode]，配合追加 CSS
	// 强制覆盖深浅色变量。读取失败或 mode 为 normal 时保持原行为（跟随系统）。
	(function () {
		try {
			if (!window.location || window.location.pathname.indexOf('/cgi-bin/luci') === -1)
				return;

			var css = [
				'html[data-design-mode="light"] { --bg: #f1f4f5; --mainbg: #fff; --bgwhite: #fff; --active_color: #5ea69b; --active_bottom: #51c291 2px solid; --text_color: rgb(132,119,116); --border_color: rgba(0,0,0,.15); --navbg_color: rgba(255,255,255,.7); --nav_border: 1px solid #f2f2f2; --sectionbg_color: #fff; --sectionbg_color2: #fff; --section_shaddow: 3px 3px 3px rgba(0,0,0,.05); --section_border: none; --sectiontab_border: none; --tabmenu_border_lr: none; --tabmenubg_color: none; --tabmenu_bottom: #e4eaec 1px solid; --tabmenu_radius: 0; --sectionnode_border: #f7f7f7 1px solid; --cbiline_color: #f7f7f7 1px solid; --tabbg_color: #fff; --inputbg_color: #f8f8f8; --inputtext_color: #76838f; --input_border: 1px solid #e4eaec; --mainleftbg_color: rgb(255,255,255); --bttext_color: #fff; --badgebg_color: #f7f7f7; --badge_border: #e4eaec 1px solid; --progressbar_color: #c8c8c8; --progressbar: #5ea69b; --progressbartxt_color: #fff; --logo_color: #222b36; --alert_color: #000000; --alert_background: rgb(230 230 230); --model_background: #ffffff; --model_text_color: #333333; --scrollbar_color: #d0d0d0; }',
				'html[data-design-mode="dark"] { --bg: #000; --bgwhite: #000; --text_color: #fefefe; --active_color: #5ea69b; --active_bottom: #51c291 2px solid; --border_color: #2C2C3A; --navbg_color: hsla(0,0%,7%,.8); --nav_border: 1px solid #1c1c1e; --sectionbg_color: #1c1c1e; --sectionbg_color2: #1c1c1e; --section_shaddow: 3px 3px 3px rgba(0,0,0,.05); --section_border: none; --sectiontab_border: none; --sectionnode_border: #3d3d41 1px solid; --cbiline_color: #2d2d2d 1px solid; --tabbg_color: #1c1c1e; --tabmenu_border_lr: none; --tabmenubg_color: none; --tabmenu_bottom: #2d2d2d 1px solid; --tabmenu_radius: 6px 6px 0 0; --inputbg_color: #2f2f2f; --inputtext_color: #fefefe; --input_border: 1px solid #4d4d4d; --mainleftbg_color: #000; --bttext_color: #fefefe; --badgebg_color: #fefefe; --badge_border: #3d3d40 1px solid; --progressbar_color: #6d6d6d; --progressbar: #5ea69b; --progressbartxt_color: #fefefe; --logo_color: #fefefe; --alert_color: #ffffff; --alert_background: rgb(30 30 30); --model_background: #2c2c2e; --model_text_color: #fefefe; --scrollbar_color: #4a4a4a; }'
			].join('\n');

			var st = document.createElement('style');
			st.textContent = css;
			document.head.appendChild(st);

			var apply = function (mode) {
				var el = document.documentElement;
				if (mode === 'light' || mode === 'dark')
					el.setAttribute('data-design-mode', mode);
				else
					el.removeAttribute('data-design-mode');
			};

			var xhr = new XMLHttpRequest();
			xhr.open('POST', '/cgi-bin/luci/admin/ubus', true);
			xhr.setRequestHeader('Content-Type', 'application/json');
			xhr.onreadystatechange = function () {
				if (xhr.readyState !== 4)
					return;
				try {
					var res = JSON.parse(xhr.responseText);
					var values = res && res.result && res.result.values;
					if (!values)
						return;
					var mode = null;
					for (var sid in values) {
						var s = values[sid];
						if (s && (s['.type'] === 'global' || sid === 'global') && s.mode)
							mode = s.mode;
					}
					apply(mode);
				} catch (e) {}
			};
			xhr.send(JSON.stringify({ jsonrpc: '2.0', id: 1, method: 'get', params: [ 'design' ], object: 'uci' }));
		} catch (e) {}
	})();
})(jQuery);
