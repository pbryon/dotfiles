# dotfiles

Yet another dotfiles repo. Mine might be different in the following aspects.

- [dotfiles](#dotfiles)
  - [.bashrc](#bashrc)
    - [read_config](#read_config)
    - [load_import_files](#load_import_files)
      - [PS1](#ps1)
      - [repo alias](#repo-alias)
      - [find_file_string()](#find_file_string)
      - [not()](#not)
      - [find_git_string()](#find_git_string)
      - [find_name](#find-name)
      - [find_merge_conflict()](#find_merge_conflict)
      - [git aliases](#git-aliases)
      - [gitall()](#gitall)
      - [git log()](#git-log)
      - [git reset to](#git-reset-to)
      - [git refork](#git-refork)
      - [git tags](#git-tags)
      - [school](#school)
  - [PowerShell functions](#powershell-functions)
      - [tail](#tail)
      - [newest](#newest)
  - [Rprofile.site](#rprofilesite)
  - [Git hooks](#git-hooks)
  - [Scripts](#scripts)
    - [touchpad.sh](#touchpadsh)
    - [update.sh](#updatesh)
  - [VSCode](#vscode)
    - [`save-extensions.sh`](#save-extensionssh)
    - [`update-extensions.sh`](#update-extensionssh)
  - [web directory](#web-directory)

## .bashrc

### read_config

My `.bashrc` uses a config file (`.bashrc.conf`) to read config parameters:

* *REPO*: the directory you clone repositories to
* *GIT*: the drectory used for local machine remotes
* *SCHOOL*: the directory where I keep my school files
* *FIND_FILE_IGNORE*: regex of folders to ignore when using [find_file_string](#find_file_string) and [find_git_string](#find_git_string)

These are then read in the `read_config()` functions in [repo.sh](#repo-alias) and [school.sh](#school) to export environment variables.

### load_import_files

This function imports sources into the .bashrc.

```shell
import_files=(ps1 repo git-log git-all find-git-string school)
load_import_files
```

Each of these sources can be found in the `bash` subdirectory.

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

If you want to use these aliases without using `read_config()`, add the following line to the `.bashrc` before the `load_import_files` function call:

`export REPO=<directory to your repositories>`

and remove the `read_config` line and/or function.

#### find_file_string()

**Source**: `find-file-string.sh`

**Default alias**: ff (configurable in the source file)

Finds a string in the current directory's files (based on `find . -type f`).

Usage:

```
ff [extension] <pattern>

With no extension, it will search all files.

If the pattern ends with a bang (!), it's case sensitive
```

Examples:

| Command | Description |
| --- | --- |
| ff foo | Looks for case insensitive string "foo" |
| ff foo! | Looks for the case sensitive string "foo" |
| ff cs foo | Looks for the case insensitive string in all `.cs` files |

#### find_name

**Source**: `find-file-string.sh`

**Default alias**: fn (configurable in the source file)

Finds a file in the current direcotry and subdirectories by name

Usage:

```
fn <pattern>
```

#### not()

**Source**: `find-file-string.sh`

```bash
Excludes the given pattern and filters out empty lines

Usage:
not <pattern>
```

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

#### find_merge_conflict()

**Source**: `find-git-string.sh`

**Default alias**: gfc (configurable in the source file)

Finds merge conflicts based on "HEAD", "<<<<" and ">>>>"

Usage:
```
gfc         Shows files with merge conflict indicators
gfc -v      Show conflict context (grep -C)
```

#### git aliases

**Source**: `git-aliases.sh`

Contains a bunch of shorthand git aliases:

| Alias | Command |
| --- | --- |
| gaa | `git add --all` |
| gac | `git add --all && git commit -v` |
| gai | `git add --interactive` |
| gane | `git commit --amend --no-edit` |
| gb | `git branch -avv` |
| gcp | `git cherry-pick` |
| gmt | `git mergetool` |
| gs | `git status` |
| gsf | `git fetch && git status` |
| grc | `git rebase --continue` |
| grs | `git rebase --skip` |

#### gitall()

**Source**: `git-all.sh`

Runs `git $@` on all subdirectories that are git repos.

Also includes `pullall`, which runs `gitall pull`.

Checks whether each directory is a git repo by:

* Presence of .git directory
* Current git branch

#### git log()

**Source**: `git-log.sh`

| Alias | Command | Default entries shown |
| ---   | ---   | --- |
| gl    | `git log -n` | 10 |
| glp   | `git log -n` with pretty format | 200 |
| refs  | <code>git reflog &#124; head -n</code> | 10 |

#### git reset to

**Source**: `git-reset-to.sh`

Resets the current branch's HEAD to a given commit

Usage:

```
$ grt
Usage: grt <target commit>
```

#### git refork

**Source**: `git-refork.sh`

Rebases this forked repository on the upstream branch

Usage:
```
$ refork <upstream remote>
```

If left blank, the upstream remote will default to "upstream"

#### git tags

**Source**: `git-tags.sh`

Show all defined tags and their related commits.

Usage:

```shell
$ git-tags

sprint0         Finish sprint 0
  0223702   Pieter Bryon            2020-10-11 17:10:04 +0200         Add TODOs
sprint1         Finish sprint 1
  79ac3c6   vangorpdirk             2020-11-07 14:23:26 +0100          #5 create personal profile page
```

#### school

Probably of no use to you. Aliases for my school repo.

The aliases only get set when you've got a `$SCHOOL` variable in your `.bashrc.conf`

## PowerShell functions

These can be found in `./ps`

#### tail

**Source**: `tail.ps1`

Mimics UNIX `tail -f`

Usage:

```
tail <file>
```

#### newest

Lists the newest file in a directory.

**Source**: `newest.ps1`

Usage: `newest`

## Rprofile.site

The profile loaded for R Studio.

## Git hooks

These can be found in the `git_hooks` folder and have a first line comment describing their purpose.

They purposefully don't have shebangs, so they'll work in Visual Studio

## Scripts

### touchpad.sh

This script checks every second for a connected mouse (identified through the `$mouse` variable). When a mouse is connected, it disables the trackpad. When it's disconnected, it re-enables it.

This script has only ever been tested on a Lenovo ThinkPad E570, so I don't know how portable it is beyond that.

### update.sh

This script is for personal use. I would advise against using it unless you plan to fork this repo.

Syntax: `./update.sh <category>`

This script can update categories of dotfiles - run the script without arguments to see which.

For *rc files, it removes the old $HOME file and creates a symlink to the copy in the directory for this repository.

If a file already exists or when it already is a symlink with a different target, you'll be prompted whether you want to remove the old file.

## VSCode

The `vscode` directory contains two scripts:

### `save-extensions.sh`

This script exports your currently installed VSCode extensions to a text file

### `update-extensions.sh`

This script installs/updates the extensions in the text file.

It's also called by the `update.sh` script, provided you run it with one of:

```
./update.sh all
./update.sh code
./update.sh vscode
```

## web directory

This directory contains some boilerplate files for web development projects with Sass and TypeScript.
