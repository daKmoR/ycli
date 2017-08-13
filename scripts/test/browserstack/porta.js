module.exports = {
	plugins: {
		sauce: {disabled: true},
		browserstack: {
			browsers: [

				// DESKTOP
				{
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
					os_version: '7'
				}, {
					browser: 'edge',
					browser_version: 'latest',
					os: 'windows',
					os_version: '10'
				}, {
					browser: 'safari',
					browser_version: 'latest',
					os: 'os x',
					os_version: 'sierra'
				},

				// MOBILE
				{
					os: "ios",
					os_version: "10.3",
					browser: "Mobile Safari",
					device: "iPhone 7",
					browser_version: null
				},
				// {
				// 	name:'chrome_android_latest',
				// 	browser: 'chrome',
				// 	os: 'android',
				// 	os_version: '6'
				// },

				// (Latest -1) versions are done afterwards
				// {
				// 	browser: 'chrome',
				// 	browser_version: 'latest-1',
				// 	os: 'windows',
				// 	os_version: '10'
				// }
				// {
				// 	browser: 'firefox',
				// 	browser_version: 'latest-1',
				// 	os: 'windows',
				// 	os_version: '10'
				// },
				// {
				// 	browser: 'edge',
				// 	browser_version: '14', // Edge 14 often results different from 15
				// 	os: 'windows',
				// 	os_version: '10'
				// },
				// {
				// 	"os": "ios",
				// 	"os_version": "9.3",
				// 	"browser": "Mobile Safari",
				// 	"device": "iPhone 6S",
				// 	"browser_version": null
				// }, {
				// 	browser: 'safari',
				// 	browser_version: '9.1',
				// 	os: 'os x',
				// 	os_version: 'El Capitan'
				// }
			],
			defaults: {
				video: false
			},
			tunnel: {
				logFile: process.platform === 'win32' ? 'nul' : '/dev/null'
			}
		}
	}
};
