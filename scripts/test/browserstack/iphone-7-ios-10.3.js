module.exports = {
	plugins: {
		sauce: { disabled: true },
		browserstack: {
			browsers: [{
				"os": "ios",
				"os_version": "10.3",
				"browser": "Mobile Safari",
				"device": "iPhone 7",
				"browser_version": null
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
