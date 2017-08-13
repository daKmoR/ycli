module.exports = {
	plugins: {
		sauce: { disabled: true },
		browserstack: {
			browsers: [{
				browser: 'edge',
				browser_version: '14',
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
