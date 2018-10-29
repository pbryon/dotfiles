# dotfiles

Yet another dotfiles repo. Mine might be different in the following aspects.

## .bashrc

### read_config

My ``.bashrc`` uses a config file (``.bashrc.conf``) to read config parameters:

* *REPO*: the directory you clone repositories to
* *GIT*: the drectory used for local machine remotes

These are then read in the ``read_config()`` function to export environment variables, which are in turn used for the ``repo`` alias and setting the PS1.

### PS1

My PS1 shows a shorter path for ``$REPO`` and ``$HOME`` (sub)directories.

When the current directory is a git repo, it will show the git branch and status behind the directory name, filtering status for behind and ahead.

e.g. ``dotfiles(ahead) [master]$``

### repo alias

The alias ``repo`` uses ``goto_repo()`` and ``complete_repo()``. It can:
* navigate to a repository: ``repo dotfiles`` or ``repo dot<TAB`>``
* navigate and perform a git action: ``repo dot<TAB> pull``

It uses the ``$REPO`` environment variable set in [read_config()](#read_config).

If you want to use the repo alias without ``read_config()``, add the following line to the ``.bashrc``:

``export REPO=<directory to your repositories>``

and remove the ``read_config`` line.

### git functions

#### git_log()

Passes the first argument to ``git log -n ``

Default arg: ``10``

#### gitall()

Runs ``git $@`` on all subdirectories that are git repos.

Checks whether each directory is a git repo by:

* Presence of .git directory
* Current git branch

### other aliases

I use the following aliases:

| Alias | Command |
| --- | --- |
| home | ``cd $HOME`` |
| gitdir | ``cd $GITDIR`` (see [read_config()](#read_config)) |
| gaa | ``git add --all`` |
| gac | ``git add --all && git commit -v`` |
| gl | ``git_log()`` function (above) |
| gs | ``git status`` |
| gsf | ``git fetch && git status`` |
| pullall | Runs ``gitall pull`` |
| q | ``exit`` |

## Rprofile.site

The profile loaded for R Studio.

## Scripts

### touchpad.sh

This script checks every second for a connected mouse (identified through the ``$mouse`` variable). When a mouse is connected, it disables the trackpad. When it's disconnected, it re-enables it.

### update.sh

This script is for personal use. I would advise against using it unless you plan to fork this repo.

Syntax: ``./update.sh <category>``

This script can update categories of dotfiles:

* **all**: all of the below
* **bash**: updates [.bashrc and .bashrc.conf](#bashrc)
* **git**: updates .gitignore and .gitconfig
* **vim**: updates .vimrc and copies the .vim directory

For *rc files, it removes the old $HOME file and creates a symlink to the copy in the directory for this repository.

If a file already exists or when it already is a symlink with a different target, you'll be prompted whether you want to remove the old file.

## web directory

This directory contains some boilerplate files for web development projects with Sass and TypeScript.
