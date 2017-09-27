const fs = require('fs');
const path = require('path');
const semver = require('semver');

const filePath = process.cwd() + '/bower.json';
const updateJsonFilePath = process.argv[2];
const option = process.argv[3];

options = {
	mode: 'caret'
};
if (option === '--help') {
	console.log('Options:');
	console.log('--fixed');
	console.log('--tilde');
	console.log('--as-is');
	return;
}
if (option === '--fixed') {
	options.mode = 'fixed';
}
if (option === '--tilde') {
	options.mode = 'tilde';
}
if (option === '--as-is') {
	options.mode = 'as-is';
}

let bowerJson = JSON.parse(fs.readFileSync(filePath, 'utf8'));
let updateJson = JSON.parse(fs.readFileSync(updateJsonFilePath, 'utf8'));

let didSomething = false;

function prepareVersion(version) {
	if (!version || (version && typeof(version) !== 'string')) {
		return false;
	}

	let parts = version.split('.');
	let major = parseInt(parts[0].match(/\d/)) || 0;
	let minor = parseInt(parts[1].match(/\d/)) || 0;
	let patch = parseInt(parts[2].match(/\d/)) || 0;
	let semVersion = `${major}.${minor}.${patch}`;
	switch(options.mode) {
		case 'caret':
			return `^${semVersion}`;
			break;
		case 'tilde':
			return `~${semVersion}`;
			break;
		case 'fixed': {
			return `${semVersion}`;
		}
	}
	console.log(':');
	console.log(version);
	return version;
}

if (bowerJson.dependencies) {
	for (let key in bowerJson.dependencies) {
		if (bowerJson.dependencies.hasOwnProperty(key)) {
			let value = bowerJson.dependencies[key];
			let shouldBe = prepareVersion(updateJson[key]);
			console.log(shouldBe);
			if (shouldBe && shouldBe !== value) {
				bowerJson.dependencies[key] = shouldBe;
				didSomething = true;
			}
		}
	}
}

if (bowerJson.devDependencies) {
	for (let key in bowerJson.devDependencies) {
		if (bowerJson.devDependencies.hasOwnProperty(key)) {
			let value = bowerJson.devDependencies[key];
			let shouldBe = prepareVersion(updateJson[key]);
			if (shouldBe && shouldBe !== value) {
				bowerJson.devDependencies[key] = shouldBe;
				didSomething = true;
			}
		}
	}
}

if (didSomething) {
	let newBowerJson = JSON.stringify(bowerJson, null, 2);
	fs.writeFileSync(filePath, newBowerJson, 'utf8');
	console.log('[CHANGE] File ' + filePath + ' has been touched :: ' + path.basename(__filename));
}
