const fs = require('fs');
const path = require('path');
const _ = require('lodash');
const filePath = process.argv[2];

let jsonFile = JSON.parse(fs.readFileSync(filePath, 'utf8'));
let propertyPath = process.argv[4];
let didSomething = false;

if (process.argv[3] === 'get') {
	let result = (propertyPath !== undefined) ? _.get(jsonFile, propertyPath) : jsonFile;
	console.log(result);
}

if (process.argv[3] === 'get-keys') {
	let keys = (propertyPath !== undefined) ? _.keys(_.get(jsonFile, propertyPath)) : _.keys(jsonFile);
	if (keys) {
		for (let key in keys){
			if (keys.hasOwnProperty(key)) {
				console.log(keys[key]);
			}
		}
	}
}

if (process.argv[3] === 'set') {
	propertyValue = process.argv[5];
	if (propertyPath === undefined) {
		console.log('[ERROR] You have to define the path to set');
		return;
	}
	if (propertyValue === undefined) {
		console.log('[ERROR] You have to define the value to set');
		return;
	}
	if (_.get(jsonFile, propertyPath) !== propertyValue) {
		_.set(jsonFile, propertyPath, propertyValue);
		didSomething = true;
		console.log('[CHANGE] File ' + filePath + ' has been touched :: Set "' + propertyPath + '" to "' + propertyValue + '"');
	}
}


if (process.argv[3] === 'delete') {
	let pathInfo = path.parse(propertyPath);
	let parentPath = pathInfo.name;
	let propertyName = pathInfo.ext.substring(1);
	if (propertyPath === undefined) {
		console.log('[ERROR] You have to define the path to delete');
		return;
	}

	if (_.get(jsonFile, propertyPath)) {
		let parentObject = _.get(jsonFile, parentPath);
		if (parentObject.hasOwnProperty(propertyName)) {
			delete parentObject[propertyName];
			_.set(jsonFile, parentPath, parentObject);
			didSomething = true;
			console.log('[CHANGE] File ' + filePath + ' has been touched :: Delete ' + propertyPath);
		}
	}
}

if (didSomething) {
	let newJsonFile = JSON.stringify(jsonFile, null, 2);
	fs.writeFileSync(filePath, newJsonFile, 'utf8');
}
