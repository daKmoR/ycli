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

# if you have problems you can manually call ./install.sh
# if installed via npm it would be cd $(npm root -g)/ycli && ./install.sh
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

*Currently known plugins:*

- [ycli-wct-browserstack](https://github.com/daKmoR/ycli-wct-browserstack)

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

```
$ ls
iron-icon  iron-image  paper-button  paper-slider

$ ycli multiple set paper-*
[INFO] The following components will be affected
- /mnt/c/html/paper-button
- /mnt/c/html/paper-slider

$ ycli multiple add iron-icon
[INFO] The following components will be affected
- /mnt/c/html/paper-button
- /mnt/c/html/paper-slider
- /mnt/c/html/iron-icon

$  ycli multiple ycli bower release-check
[START] Do "ycli bower release-check" for the following 3 components
- /mnt/c/html/paper-button
- /mnt/c/html/paper-slider
- /mnt/c/html/iron-icon
[START] (1/3) Component /mnt/c/html/paper-button
✓ Bower Repository has the same latest version 2.0.0
[DONE] (1/3) Component /mnt/c/html/paper-button

[START] (2/3) Component /mnt/c/html/paper-slider
✓ Bower Repository has the same latest version 2.0.2
[DONE] (2/3) Component /mnt/c/html/paper-slider

[START] (3/3) Component /mnt/c/html/iron-icon
✓ Bower Repository has the same latest version 2.0.1
[DONE] (3/3) Component /mnt/c/html/iron-icon

[DONE] Multiple Actions Duration: 8.89s

$ ycli multiple git pull
[START] Do "git pull" for the following 3 components
- /mnt/c/html/paper-button
- /mnt/c/html/paper-slider
- /mnt/c/html/iron-icon
[START] (1/3) Component /mnt/c/html/paper-button
Already up-to-date.
[DONE] (1/3) Component /mnt/c/html/paper-button

[START] (2/3) Component /mnt/c/html/paper-slider
Already up-to-date.
[DONE] (2/3) Component /mnt/c/html/paper-slider

[START] (3/3) Component /mnt/c/html/iron-icon
Already up-to-date.
[DONE] (3/3) Component /mnt/c/html/iron-icon

[DONE] Multiple Actions Duration: 3.26s
```

It let's you execute a command for a defined list of directories. For example you can just do a git pull for all your
element by typing `ycli multiple git pull`. It does this sequentially one after each other.

Some commands may be run more efficiently in parallel because they depend on network or other resources. To run a command
in parallel just add --jobs x to it. e.g. `ycli multiple git pull --jobs 4`. This will spawn 4 bash jobs. Keep in mind
that for smaller tasks the spawing might take longer then the command itself. So `git pull` is a good example that can
use multiple jobs - `rm someTmpFile.txt` will be much fast just run in one bash in sequential order.

For more information see `ycli multiple --help`.

**ycli bower dependency-tree**

Displays a dependency tree (incl. versions with set option) that can be filtered via a pattern.

```
$ cd paper-button
$ ycli bower dependency-tree -v --pattern paper-
paper-button
├─ paper-behaviors#2.0.0 (1 - 2)
│  └─ paper-ripple#2.0.1 (1 - 2)
└─ paper-styles#2.0.0 (1 - 2)
```

Use autocomplete (tab, tab) to show all Commands or SubCommands.
