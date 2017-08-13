module.exports = {
	plugins: {
		sauce: { disabled: true },
		browserstack: {
			browsers: [{
				browser: 'safari',
				browser_version: '9.1',
				os: 'os x',
				os_version: 'El Capitan'
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
