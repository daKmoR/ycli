module.exports = {
	plugins: {
		sauce: { disabled: true },
		browserstack: {
			browsers: [{
				browser: 'chrome',
				browser_version: 'latest',
				os: 'windows',
				os_version: '10'
			}, {
				browser: 'firefox',
				browser_version: 'latest',
				os: 'windows',
				os_version: '10'
			}, {
				browser: 'ie',
				browser_version: '11',
				os: 'windows',
				os_version: '10'
			}, {
				browser: 'edge',
				browser_version: '15',
				os: 'windows',
				os_version: '10'
			}, {
				browser: 'safari',
				browser_version: '10.1',
				os: 'os x',
				os_version: 'sierra'
			}],
			defaults: {
				video: false
			},
			tunnel: {
				logFile: process.platform === 'win32' ? 'nul' : '/dev/null'
			}
		}
	}
};
