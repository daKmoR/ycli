const fs = require('fs');
const path = require('path');
const _ = require('lodash');

let options = {
	jsonFilePaths: [],
	method: '',
	propertyPath: ''
};

let params = process.argv;
for (let key = 0; key < process.argv.length; key++) {
	let param = params[key];
	switch (param) {
		case '-fs':
		case '--files':
			let i = key+1;
			while (i < process.argv.length) {
				if (fs.existsSync(params[i])) {
					options.jsonFilePaths.push(params[i]);
					i++;
				} else {
					break;
				}
			}
			key = (i-1);
			break;
		case '-f':
		case '--file':
			options.jsonFilePaths.push(params[key+1]);
			break;
		case 'd':
		case 'delete':
			options.method = 'delete';
			options.propertyPath = params[key+1];
			break;
		case 's':
		case 'set':
			options.method = 'set';
			options.propertyPath = params[key+1];
			options.propertyValue = params[key+2];
			break;
		case 'gk':
		case 'get-keys':
			options.method = 'get-keys';
			options.propertyPath = params[key+1];
			break;
		case 'gkm':
		case 'get-merged-keys':
			options.method = 'get-merged-keys';
			options.propertyPath = params[key+1];
			break;
		case 'g':
		case 'get':
			options.method = 'get';
			options.propertyPath = params[key+1];
			break;
		case 'gm':
		case 'get-merged':
			options.method = 'get-merged';
			options.propertyPath = params[key+1];
			break;
		case '--help':
			console.log('');
			console.log('Json Reader');
			console.log('');
			console.log('Commands:');
			console.log('  get: g:');
			console.log('    Returns the value of the given path');
			console.log('  get-keys: gk:');
			console.log('    Returns the keys of the given path');
			console.log('  set: s:');
			console.log('    Sets the value of the given path');
			console.log('  delete: d:');
			console.log('    Removes the given path');
			console.log('  get-merged: gm:');
			console.log('    Merges all given files in order and returns the value of the given path');
			console.log('  get-merged-keys: gmk:');
			console.log('    Merges all given files in order and returns the key of the given path');
			console.log('');
			console.log('Options:');
			console.log('  --file: -f:');
			console.log('    Defines a file to process. Multiple --file can be used');
			console.log('  --files: -fs:');
			console.log('    Defines files (separated by space) to be used');
			console.log('');
			console.log('Examples:');
			console.log('  json get repository.url --file package.json');
			console.log('    => possible return could be "http://..."');
			console.log('  json set version 1.2.0 --file package.json --file bower.json');
			console.log('  json set version 1.2.0 --files package.json bower.json');
			console.log('    => sets version in package.json and bower.json');
			console.log('  json get-merged property.subProperty --files ~/config.json ../config.json ./config.json');
			console.log('    => 1) Starts with values from ~/config.json');
			console.log('       2) Merges ../config.json and ./config.json (e.g. ./config.json has the highest priority');
			console.log('       3) returns the value of property.subProperty');
			console.log('');
			return;
			break;
	}
}

if (options.jsonFilePaths.length === 0) {
	console.log('[ERROR] You have to define at least one --file /path/to/file.json');
	return 1;
}

if (options.method === 'get-merged' || options.method === 'get-merged-keys') {
	let jsonData = {};

	for (let jsonFilePath of options.jsonFilePaths) {
		let currentJsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
		jsonData = _.merge(jsonData, currentJsonData);
	}

	//
	// get-merged
	//
	if (options.method === 'get-merged') {
		let result = (options.propertyPath !== undefined) ? _.get(jsonData, options.propertyPath) : jsonData;
		console.log(result);
	}

	//
	// get-merged-keys
	//
	if (options.method === 'get-merged-keys') {
		let keys = (options.propertyPath !== undefined) ? _.keys(_.get(jsonData, options.propertyPath)) : _.keys(jsonData);
		if (keys) {
			for (let key in keys){
				if (keys.hasOwnProperty(key)) {
					console.log(keys[key]);
				}
			}
		}
	}

}



for (let jsonFilePath of options.jsonFilePaths) {
	let didSomething = false;
	let jsonData = {};
	if (fs.existsSync(jsonFilePath)) {
		let jsonData = JSON.parse(fs.readFileSync(jsonFilePath, 'utf8'));
	}

	//
	// get
	//
	if (options.method === 'get') {
		let result = (options.propertyPath !== undefined) ? _.get(jsonData, options.propertyPath) : jsonData;
		console.log(result);
	}

	//
	// get-keys
	//
	if (options.method === 'get-keys') {
		let keys = (options.propertyPath !== undefined) ? _.keys(_.get(jsonData, options.propertyPath)) : _.keys(jsonData);
		if (keys) {
			for (let key in keys){
				if (keys.hasOwnProperty(key)) {
					console.log(keys[key]);
				}
			}
		}
	}

	//
	// set
	//
	if (options.method === 'set') {
		if (options.propertyPath === undefined) {
			console.log('[ERROR] You have to define the path to set');
			return;
		}
		if (options.propertyValue === undefined) {
			console.log('[ERROR] You have to define the value to set');
			return;
		}
		if (_.get(jsonData, options.propertyPath) !== options.propertyValue) {
			_.set(jsonData, options.propertyPath, options.propertyValue);
			didSomething = true;
			console.log('[CHANGE] File ' + jsonFilePath + ' has been touched :: Set "' + options.propertyPath + '" to "' + options.propertyValue + '"');
		}
	}

	//
	// delete
	//
	if (options.method === 'delete') {
		let pathInfo = path.parse(options.propertyPath);
		let parentPath = pathInfo.name;
		let propertyName = pathInfo.ext.substring(1);
		if (options.propertyPath === undefined) {
			console.log('[ERROR] You have to define the path to delete');
			return;
		}

		if (_.get(jsonData, options.propertyPath)) {
			let parentObject = _.get(jsonData, parentPath);
			if (parentObject.hasOwnProperty(propertyName)) {
				delete parentObject[propertyName];
				_.set(jsonData, parentPath, parentObject);
				didSomething = true;
				console.log('[CHANGE] File ' + jsonFilePath + ' has been touched :: Delete ' + options.propertyPath);
			}
		}
	}

	if (didSomething) {
		let newJsonFile = JSON.stringify(jsonData, null, 2);
		fs.writeFileSync(jsonFilePath, newJsonFile, 'utf8');
	}

}
