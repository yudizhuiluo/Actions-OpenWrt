'use strict';
'require baseclass';

return baseclass.extend({
	title: _('技术支持'),
	render: function() {
		return E('p', { 'class': 'technical-support' }, [
			E('a', { 'href': 'https://xingchenns.top', 'target': '_green' }, '我的网站')
		]);
	}
});
