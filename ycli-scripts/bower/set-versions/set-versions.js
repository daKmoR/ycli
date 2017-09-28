const fs = require('fs');
const path = require('path');
const semver = require('semver');

const filePath = process.cwd() + '/bower.json';
const updateJsonFilePath = process.argv[2];
let bowerJson = JSON.parse(fs.readFileSync(filePath, 'utf8'));
let updateJson = JSON.parse(fs.readFileSync(updateJsonFilePath, 'utf8'));

options = {
	mode: 'caret',
	smartSet: false
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
		case '-s':
		case '--smart-set':
			options.smartSet = true;
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
			console.log('  -s --smart-set: tries to set to the optimal compatibility version');
			console.log('      e.g. is: 2.0.3 should be: 2.0.7 => 2.0.3');
			console.log('      e.g. is: 2.0.3 should be: 2.1.3 => 2.1.0');
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

function prepareShouldBeVersion(version, currentVersion) {
	if (!version || (version && typeof(version) !== 'string')) {
		return false;
	}

	let semVerParts = getSemVerParts(version);

	if (semVerParts) {
		if (currentVersion) {
			let currentSemVerParts = getSemVerParts(currentVersion);
			if (currentSemVerParts) {
				if (options.smartSet) {
					if (currentSemVerParts.major === semVerParts.major && currentSemVerParts.minor === semVerParts.minor) {
						semVerParts.patch = currentSemVerParts.patch;
					} else {
						semVerParts.patch = 0;
					}
				}
			}
		}
		let semVersion = `${semVerParts.major}.${semVerParts.minor}.${semVerParts.patch}${semVerParts.postfix}`;

		switch(options.mode) {
			case 'caret':
				return `${semVerParts.prefix}^${semVersion}`;
				break;
			case 'tilde':
				return `${semVerParts.prefix}~${semVersion}`;
				break;
			case 'fixed': {
				return `${semVerParts.prefix}${semVersion}`;
			}
		}
	}

	return version;
}

function getSemVerParts(version) {
	let result = version.match(/([\w\/\-]*)#?.?(\d)\.(\d).(\d)(.*)/);
	if (result) {
		return {
			prefix: result[1] ? result[1] + '#' : '',
			major: parseInt(result[2]),
			minor: parseInt(result[3]),
			patch: parseInt(result[4]),
			postfix: result[5]
		};
	}
	return false;
}

if (bowerJson.dependencies) {
	for (let key in bowerJson.dependencies) {
		if (bowerJson.dependencies.hasOwnProperty(key)) {
			let value = bowerJson.dependencies[key];
			let shouldBe = prepareShouldBeVersion(updateJson[key], value);
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
			let shouldBe = prepareShouldBeVersion(updateJson[key], value);
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
