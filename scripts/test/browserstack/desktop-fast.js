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
