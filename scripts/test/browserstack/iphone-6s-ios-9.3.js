module.exports = {
	plugins: {
		sauce: { disabled: true },
		browserstack: {
			browsers: [{
				"os": "ios",
				"os_version": "9.3",
				"browser": "Mobile Safari",
				"device": "iPhone 6S",
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
