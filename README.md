# BASH3 Boilerplate by krisztianmukli
 forked and customized from [kvz/bash3boilerplate](https://github.com/kvz/bash3boilerplate)

* [Overview](#overview)
* [Goals](#goals)
* [What we changed](#what-we-changed)
* [Features](#features)
* [Installation](#installation)
* [Changelog](#changelog)
* [Frequently Asked Questions](#frequently-asked-questions)
* [Best Practices](#best-practices)
* [Who uses b3bp](#who-uses-b3bp)
* [Authors](#authors)
* [License](#license)

## Overview

<!--more-->

When hacking up Bash scripts, there are often things such as logging or command-line argument parsing that:

 - You need every time
 - Come with a number of pitfalls you want to avoid
 - Keep you from your actual work
 
Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most scripts.

We call it "BASH3 Boilerplate by krisztianmukli" or b3bp for short.

## Goals

The aim of this project is that we create a standardized bash-script template, 
which is contains this pre-defined functions, simple to configure and it use 
best practices as many as possible. This template based on original 
[BASH3 Boilerplate](https://github.com/kvz/bash3boilerplate), that we 
customized based on some point-of view, which may not target to the original 
project.

Delete-Key-**Friendly**. Instead of introducing packages, includes, compilers, 
etc., we propose using [`main.sh`](http://bash3boilerplate.sh/main.sh) as a 
base and removing the parts you don't need.
While this may feel a bit archaic at first, it is exactly the strength of Bash 
scripts that we should want to embrace.

**Portable**. We are targeting Bash 3 (OSX still ships
with 3, for instance). If you are going to ask people to install
Bash 4 first, you might as well pick a more advanced language as a
dependency.

## What we changed

**Complex comment-structure**. We are using a pre-defined descriptive file header, 
which is contains detailed information about the script (name, description, 
license, todo, change-log, etc.). We are splitting four section to our scripts, 
marked that comments:

- Init section: set environment variables
- Global section: set global variables
- Functions section: contains functions, that is called from main section
- Main section: parse usage string, parse and validate command-line arguments, 
call helper and internal functions, finally start the main process.

**Function headers**. Every function has a comment-header, contains a 
description and lists of used arguments and return values of function.

**Script-specific variable names**. Global variable of script use the following 
scheme: __b3bp_var (and __b3bp_arg_a for command-line arguments). 

**Coding style**. We are using 
[Google Shell Style Guide](https://google.github.io/styleguide/shell.xml) and 
[Fritz Mehner: Bash Style Guide And Coding Standard](https://lug.fh-swf.de/vim/vim-bash/StyleGuideShell.en.pdf) 
(except when it conflict with Shell Style Guide)

**Built-in localization**. Using bash built-in internationalizing function, 
localizing bash scripts in a standard way is fairly possible. 
For more information and a good tutorial, see: [http://mywiki.wooledge.org/BashFAQ/098](http://mywiki.wooledge.org/BashFAQ/098)

**More modules**. We separated some reusable code-patterns to .sh-files, which are sourcable when it need. Such as log (log.sh), simple question (ask.sh), read and write ini-files (ini_val.sh), help functions (display_info.sh) and OS-detection (os_detection.sh). We are keeping original b3bp libraries: megamount.sh, parse_url and templater.sh.
Creating more libraries is in progress...

**Standalone installer and remover**. We are create a simple installer, which is detect the used OS and it can copy the specified script file and it's libraries and dependencies to an appropriate folder, and/or add them to the PATH. These is storing information about the script in the installer.ini file, which is copying to script's final destination. It could be used for initalize the script, but it's not required, in such case it will be store information only for install/remove.

**Removed features:** we are removed every feature and file, that we aren't need
or don't use it, such as files of website, npm, travis and such else...

## Features

- Conventions that will make sure that all your scripts follow the same, battle-tested structure
- Safe by default (break on error, pipefail, etc.)
- Configuration by environment variables
- Simple command-line argument parsing that requires no external dependencies. Definitions are parsed from help info, ensuring there will be no duplication
- Helpful magic variables like `__b3p_file` and `__3bp_dir`
- Logging that supports colors and is compatible with [Syslog Severity levels](http://en.wikipedia.org/wiki/Syslog#Severity_levels)

## Limitations

The original BASH3 Boilerplate project targeted to OS-agnostic way, 
but we use scripting and testing only Debian-based systems. Maybe some our 
modification doesn't compatible with other distributions, sorry for the inconvenience, 
please test it carefully!

## Installation

### Clone the entire project

Besides `b3bp`, this will also get you the entire b3bp repository. This includes a few extra functions that we keep in the `./lib` directory.

```bash
git clone git@github.com:krisztianmukli/bash3boilerplate.git
```
## Changelog

Please see the [CHANGELOG.md](./CHANGELOG.md) file.

## Frequently Asked Questions

Please see the [FAQ.md](./FAQ.md) file.

## Best practices

As of `v1.0.0`, b3bp offers some nice re-usable libraries in `./lib`. In order to make the snippets in `./lib` more useful, we recommend the following guidelines.

### Function packaging

It is nice to have a Bash package that can not only be used in the terminal, but also invoked as a command line function. In order to achieve this, the exporting of your functionality *should* follow this pattern:

```bash
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
  export -f my_script
else
  my_script "${@}"
  exit $?
fi
```

This allows a user to `source` your script or invoke it as a script.

```bash
# Running as a script
$ ./my_script.sh some args --blah
# Sourcing the script
$ source my_script.sh
$ my_script some more args --blah
```

(taken from the [bpkg](https://raw.githubusercontent.com/bpkg/bpkg/master/README.md) project)

### Scoping

1. In functions, use `local` before every variable declaration.
1. Use `UPPERCASE_VARS` to indicate environment variables that can be controlled outside your script.
1. Use `__double_underscore_prefixed_vars` to indicate global variables that are solely controlled inside your script, with the exception of arguments that are already prefixed with `__b3bp_arg_`, as well as functions, over which b3bp poses no restrictions.

### Coding style

1. Use two spaces for tabs, do not use tab characters.
1. Do not introduce whitespace at the end of lines or on blank lines as they obfuscate version control diffs.
1. Use long options (`logger --priority` vs `logger -p`). If you are on the CLI, abbreviations make sense for efficiency. Nevertheless, when you are writing reusable scripts, a few extra keystrokes will pay off in readability and avoid ventures into man pages in the future, either by you or your collaborators. Similarly, we prefer `set -o nounset` over `set -u`.
1. Use a single equal sign when checking `if [[ "${NAME}" = "Kevin" ]]`; double or triple signs are not needed.
1. Use the new bash builtin test operator (`[[ ... ]]`) rather than the old single square bracket test operator or explicit call to `test`.

### Safety and Portability

1. Use `{}` to enclose your variables. Otherwise, Bash will try to access the `$ENVIRONMENT_app` variable in `/srv/$ENVIRONMENT_app`, whereas you probably intended `/srv/${ENVIRONMENT}_app`. Since it is easy to miss cases like this, we recommend that you make enclosing a habit.
1. Use `set`, rather than relying on a shebang like `#!/usr/bin/env bash -e`, since that is neutralized when someone runs your script as `bash yourscript.sh`.
1. Use `#!/usr/bin/env bash`, as it is more portable than `#!/bin/bash`.
1. Use `${BASH_SOURCE[0]}` if you refer to current file, even if it is sourced by a parent script. In other cases, use `${0}`.
1. Use `:-` if you want to test variables that could be undeclared. For instance, with `if [ "${NAME:-}" = "Kevin" ]`, `$NAME` will evaluate to `Kevin` if the variable is empty. The variable itself will remain unchanged. The syntax to assign a default value is `${NAME:=Kevin}`.


## Authors

- [Krisztián Mukli](https://www.mukli.hu)

### Original b3bp authors
- [Kevin van Zonneveld](http://kvz.io)
- [Izaak Beekman](https://izaakbeekman.com/)
- [Manuel Streuhofer](https://github.com/mstreuhofer)
- [Alexander Rathai](mailto:Alexander.Rathai@gmail.com)
- [Dr. Damian Rouson](http://www.sourceryinstitute.org/) (documentation, feedback)
- [@jokajak](https://github.com/jokajak) (documentation)
- [Gabriel A. Devenyi](http://staticwave.ca/) (feedback)
- [@bravo-kernel](https://github.com/bravo-kernel) (feedback)
- [@skanga](https://github.com/skanga) (feedback)
- [galaktos](https://www.reddit.com/user/galaktos) (feedback)
- [@moviuro](https://github.com/moviuro) (feedback)
- [Giovanni Saponaro](https://github.com/gsaponaro) (feedback)
- [Germain Masse](https://github.com/gmasse)
- [A. G. Madi](https://github.com/warpengineer)

## License

Copyright &copy; 2018 Krisztián Mukli and [contributors](https://github.com/kvz/bash3boilerplate#authors). Licensed under [MIT](https://raw.githubusercontent.com/krisztianmukli/bash3boilerplate/master/LICENSE).

Copyright &copy; 2013 Kevin van Zonneveld and [contributors](https://github.com/kvz/bash3boilerplate#authors). Licensed under [MIT](https://raw.githubusercontent.com/kvz/bash3boilerplate/master/LICENSE).
You are not obligated to bundle the LICENSE file with your b3bp projects as long
as you leave these references intact in the header comments of your source files.
