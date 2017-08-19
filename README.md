Your/Yo CLI
=============

Installation
------------

Use ONE of the following methods:
```
# install via npm
npm install --global ycli

# install via git
git clone git@github.com:daKmoR/ycli.git && cd ycli && npm install
```

Restart your Terminal/Console!!!

Usage
-----

Just open a terminal and type

```
ycli
```

Should show something like this
```
Your/Yo CLI

Available Commands:
    ycli bower
    ycli config
    ycli git-lab
    ycli git
    ycli help
    ycli multiple
    ycli release
    ycli self-update
    ycli util
    ycli wct

Example:
    ycli self-update
```

Extending Ycli
--------------

Ycli is explicitly designed around the idea of easily adding new commands.

### Local Scripts

- For commands that should only be available within this specific project/folder.

Add a folder `ycli-scripts` in your current folder and all `*.sh *.js` files will be visible as commands.

Example:

	mkdir ycli-scripts # create needed folder
	touch ycli-scripts/my-local-script.sh # add new script
	ycli
	...
	Available Commands:
	  ycli my-local-script
	...

### Global Plugins

- For commands that should be available within your whole system.

**Available Plugins**

Search for `ycli-` on npm/github. Usually you can easily install it either via
`npm -g install <name>` or clone/copy it into your home folder.

**System**

A Plugin is automatically identified if it starts with `ycli-` and resists in on of the following folders.

- global npm dir (`npm root -g`)
- same level as ycli itself (`dirname $YCLI_DIR`)
- users home (`echo ~`)

**Simple Global Plugin**

If you wish to have something globally just do the following:

	mkdir -p ~/ycli-user-plugin/ycli-scripts # create needed plugin
	touch ~/ycli-user-plugin/ycli-scripts/my-user-script.sh # add new script
	_ycliFindPlugins # or just restart your terminal/console
	ycli
	...
	Available Commands:
	  ycli my-user-script
	...

`ycli-user-plugin` could easily also be a git repository so you can collaborate with your friends/colleagues.
Once you are satisfied you could also publish it on npm.

### Your own CLI

- If you wish to brand `ycli` or split it up into multiple CLIs.

This is a more complex extension and requires you to provide your own autocomplete and install/uninstall methods.
But you get a complete separate cli which internally can still use ycli features.

Lucky for you it's just some boilerplate you can copy from [Super Cli Example](https://github.com/daKmoR/super-cli-example).

What you get is a new command
```
$ super-cli

The Super CLI Example

Available Commands:
    super-cli bower
    super-cli config
    super-cli git-lab
    super-cli git
    super-cli help
    super-cli multiple
    super-cli release
    super-cli self-update
    super-cli util
    super-cli wct

Example:
    super-cli self-update
```

The available commands and if it will use default ycli plugins or other plugins is complete up to you in this case.

Highlights
----------

**ycli multiple**

It let's you execute a command for a defined list of directories. For example you can just do a git pull for all your
element by typing `ycli multiple git pull`. It does this sequentially one after each other.

Some commands may be run more efficiently in parallel because they depend on network or other resources. To run a command
in parallel just add --jobs x to it. e.g. `ycli multiple git pull --jobs 4`. This will spawn 4 bash jobs. Keep in mind
that for smaller tasks the spawing might take longer then the command itself. So `git pull` is a good example that can
use multiple jobs - `rm someTmpFile.txt` will be much fast just run in one bash in sequential order.

For more information see `ycli multiple --help`.

Use autocomplete (tab, tab) to show all Commands or SubCommands.
