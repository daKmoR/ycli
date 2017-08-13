const fs = require('fs');
const path = require('path');
const treeify = require('treeify');

const exec = require('child_process').exec;
const cacheFilePath = process.cwd() + '/.bower-list-cache.json';

let options = {
	'includeDevDependencies': false,
	'pattern': new RegExp(/./)
};

let params = process.argv;
for (let key of params.keys()) {
	let param = params[key];
	switch (param) {
		case '-p':
		case '--pattern':
			options.pattern =  new RegExp(params[key+1]);
			break;
		case '-d':
		case '--include-dev-dependencies':
			options.includeDevDependencies = true;
			break;
		case '-v':
		case '--versions':
			options.includeVersions = true;
			break;
		case '--help':
			console.log('');
			console.log('Bower Dependency Tree');
			console.log('');
			console.log('This displays the dependency tree of the current element.');
			console.log('');
			console.log('Options:');
			console.log('  -d --include-dev-dependencies: also use bowers devDependencies for the tree');
			console.log('  -p --pattern: Filter tree for [Defaults to "."]');
			console.log('  -v --versions: Include the versions of the dependencies');
			console.log('');
			console.log('Examples:');
			console.log('  dependency-tree -d');
			console.log('    => shows full tree with dev dependencies');
			console.log('  dependency-tree --pattern "."');
			console.log('    => show all dependencies e.g. no filtering');
			console.log('  dependency-tree -d --pattern "iron-"');
			console.log('    => show full tree  only iron- dependencies');
			console.log('');
			console.log('FAQ:');
			console.log('  If you get an buffer error you can also provide a cached version of bower list. To create it just call');
			console.log('    bower list --offline --json > .bower-list-cache.json');
			console.log('  in your command line.');
			return;
			break;
	}
}

if (fs.existsSync(cacheFilePath)) {
	let bowerJson = JSON.parse(fs.readFileSync(cacheFilePath, 'utf8'));
	let tree = {};
	tree[bowerJson.pkgMeta.name] = preparePkg(bowerJson, options);
	console.log(treeify.asTree(tree, true));

} else {
	exec("bower list --offline --json", {maxBuffer: 1024 * 1024 * 10}, function (error, stdout, stderr) {
		if (error !== null) {
			console.log('exec error: ' + error);
			console.log('If you get an error you can also provide a cached version of bower list. To create it just call');
			console.log('  bower list --offline --json > .bower-list-cache.json');
			console.log('in your command line.');
			return;
		}

		let bowerJson = JSON.parse(stdout);
		console.log(bowerJson.pkgMeta.name);
		console.log(treeify.asTree(preparePkg(bowerJson, options), true));
	});

}

function preparePkg(pkgObject, options) {
	let pkgTree = {};
	if (pkgObject.pkgMeta && pkgObject.pkgMeta.name) {
		let wantedDependencies = [];
		if (pkgObject.pkgMeta.dependencies) {
			for (let key of Object.keys(pkgObject.pkgMeta.dependencies)) {
				if (key.match(options.pattern)) {
					wantedDependencies.push(key);
				}
			}
		}
		if (options.includeDevDependencies === true) {
			if (pkgObject.pkgMeta.devDependencies) {
				for (let key of Object.keys(pkgObject.pkgMeta.devDependencies)) {
					if (key.match(options.pattern)) {
						wantedDependencies.push(key);
					}
				}
			}
		}
		if (pkgObject.dependencies) {
			for (let key of Object.keys(pkgObject.dependencies)) {
				if (wantedDependencies.includes(key)) {
					const targetVersion = pkgObject.dependencies[key].endpoint.target;
					const releaseVersion = pkgObject.dependencies[key].pkgMeta._release;
					const id = options.includeVersions ? `${key}#${releaseVersion} (${targetVersion})` : key;
					pkgTree[id] = preparePkg(pkgObject.dependencies[key], options);
				}
			}
		}
	}
	return pkgTree;
}
