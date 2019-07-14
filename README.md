# dotfiles

Yet another dotfiles repo. Mine might be different in the following aspects.

## .bashrc

### read_config

My `.bashrc` uses a config file (`.bashrc.conf`) to read config parameters:

* *REPO*: the directory you clone repositories to
* *GIT*: the drectory used for local machine remotes

These are then read in the `read_config()` function to export environment variables, which are in turn used for the `repo` alias and setting the PS1.

### load_import_files

This function imports sources into the .bashrc.

```shell
import_files=(ps1 repo git-log git-all find-git-string school)
load_import_files
```

Each of these sources can be found in the `.bash` subdirectory.

Please note that the above list of imports is subject to change.

#### PS1

**Source**: `ps1.sh`

My PS1 shows a shorter path for `$REPO` and `$HOME` (sub)directories.

When the current directory is a git repo, it will show the git branch and status behind the directory name, filtering status for behind and ahead.

e.g. `dotfiles(ahead) [master]$`

#### repo alias

**Source**: `repo.sh`

The alias `repo` uses `goto_repo()` and `complete_repo()`. It can:
* navigate to a repository: `repo dotfiles` or `repo dot<TAB>`
* navigate and perform a git action: `repo dot<TAB> pull`

It uses the `$REPO` environment variable set in [read_config()](#read_config).

If you want to use the repo alias without `read_config()`, add the following line to the `.bashrc` before the `load_import_files` function call:

`export REPO=<directory to your repositories>`

and remove the `read_config` line and/or function.

#### find_git_string()

**Source**: `find-git-string.sh`

**Default alias**: gf (configurable in the source file)

Finds a string in the current repo's tracked files (based on `git ls-files`).

Usage:

```
gf [extension] <pattern>

With no extension, it will search all files.

If the pattern ends with a bang (!), it's case sensitive
```

Examples:

| Command | Description |
| --- | --- |
| gf foo | Looks for case insensitive string "foo" |
| gf foo! | Looks for the case sensitive string "foo" |
| gf cs foo | Looks for the case insensitive string in all `.cs` files |

#### gitall()

**Source**: `git-all.sh`

Runs `git $@` on all subdirectories that are git repos.

Checks whether each directory is a git repo by:

* Presence of .git directory
* Current git branch


#### git_log()

**Source**: `git-log.sh`

| Alias | Command | Default entries shown |
| ---   | ---   | --- |
| gl    | `git log -n` | 10 |
| glp   | `git log -n` with pretty format | 200 |
| refs  | `git reflog | head -n` | 10 |

#### school.sh

Probably of no use to you. Aliases for my school repo.

The aliases only get set when you've got a `$SCHOOL` variable in your `.bashrc.conf`

### other aliases

I use the following aliases:

| Alias | Command |
| --- | --- |
| home | `cd $HOME` |
| gitdir | `cd $GITDIR` (see [read_config()](#read_config)) |
| gaa | `git add --all` |
| gac | `git add --all && git commit -v` |
| gs | `git status` |
| gsf | `git fetch && git status` |
| pullall | Runs `gitall pull` |
| q | `exit` |

## Rprofile.site

The profile loaded for R Studio.

## Git hooks

These can be found in the `git_hooks` folder and have a first line comment describing their purpose.

They purposefully don't have shebangs, so they'll work in Visual Studio

## Scripts

### touchpad.sh

This script checks every second for a connected mouse (identified through the `$mouse` variable). When a mouse is connected, it disables the trackpad. When it's disconnected, it re-enables it.

### update.sh

This script is for personal use. I would advise against using it unless you plan to fork this repo.

Syntax: `./update.sh <category>`

This script can update categories of dotfiles - run the script without arguments to see which.

For *rc files, it removes the old $HOME file and creates a symlink to the copy in the directory for this repository.

If a file already exists or when it already is a symlink with a different target, you'll be prompted whether you want to remove the old file.

## web directory

This directory contains some boilerplate files for web development projects with Sass and TypeScript.
