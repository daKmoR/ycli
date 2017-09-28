const fs = require('fs');
const path = require('path');
const semver = require('semver');

const filePath = process.cwd() + '/bower.json';
const updateJsonFilePath = process.argv[2];
let bowerJson = JSON.parse(fs.readFileSync(filePath, 'utf8'));
let updateJson = JSON.parse(fs.readFileSync(updateJsonFilePath, 'utf8'));

options = {
	mode: 'caret',
	resetPatch: false
};

let params = process.argv;
for (let key of params.keys()) {
	let param = params[key];
	switch (param) {
		case '-f':
		case '--fixed':
			options.mode = 'fixed';
			break;
		case '-t':
		case '--tilde':
			options.mode = 'tilde';
			break;
		case '-a':
		case '--as-is':
			options.mode = 'as-is';
			break;
		case '-r':
		case '--reset-patch':
			options.resetPatch = true;
			break;
		case '--help':
			console.log('');
			console.log('Bower Set Versions');
			console.log('');
			console.log('Set versions as defined in a json file.');
			console.log('');
			console.log('Options:');
			console.log('  -f --fixed: set hard version e.g. 1.2.3');
			console.log('  -t --tilde: set tilde version e.g. ~1.2.3');
			console.log('  -r --reset-patch: set patch to 0 e.g. 1.2.3 becomes 1.2.0');
			console.log('  -a --as-is: Include the versions of the dependencies');
			console.log('');
			console.log('Examples:');
			console.log('  set-versions path/to/wanted-versions.json');
			console.log('    => set versions according to the content of wanted-versions.json');
			console.log('');
			return;
			break;
	}
}

let didSomething = false;

function prepareVersion(version) {
	if (!version || (version && typeof(version) !== 'string')) {
		return false;
	}

	let parts = version.split('.');
	let major = parseInt(parts[0].match(/\d/)) || 0;
	let minor = parseInt(parts[1].match(/\d/)) || 0;
	let patch = parseInt(parts[2].match(/\d/)) || 0;
	if (options.resetPatch) {
		patch = 0;
	}
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
