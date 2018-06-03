## Contents

* [What is a CLI](#what-is-a-cli)?
* [How do I incorporate BASH3 Boilerplate  by krisztianmukli into my own project](#how-do-i-incorporate-bash3-boilerplate-by-krisztianmukli-into-my-own-project)?
* [How do I add a command-line flag](#how-do-i-add-a-command-line-flag)?
* [How do I access the value of a command-line argument](#how-do-i-access-the-value-of-a-command-line-argument)?
* [What is a magic variable](#what-is-a-magic-variable)?
* [How do I submit an issue report](#how-do-i-submit-an-issue-report)?
* [How can I contribute to this project](#how-can-i-contribute-to-this-project)?
* [Why are you typing BASH in all caps](#why-are-you-typing-bash-in-all-caps)?
* [You are saying you are portable, but why won't b3bp code run in dash / busybox / posh / ksh / mksh / zsh](#you-are-saying-you-are-portable-but-why-wont-b3bp-code-run-in-dash--busybox--posh--ksh--mksh--zsh)?
* [How do I do Operating System detection](#how-do-i-do-operating-system-detection)?
* [How do I access a potentially unset (environment) variable](#how-do-i-access-a-potentially-unset-environment-variable)?
* [How can I detect or trap CTRL-C and other signals](#how-can-i-detect-or-trap-ctrl-c-and-other-signals)?
* [How can I get the PID of my running script](how-can-i-get-the-pid-of-my-running-script)?

<!--more-->

# Frequently Asked Questions

## What is a CLI?

A "CLI" is a [command-line interface](https://en.wikipedia.org/wiki/Command-line_interface).

## How do I incorporate BASH3 Boilerplate by krisztianmukli into my own project?

You can incorporate BASH3 Boilerplate by krisztianmukli into your project in one of two ways:

1. Copy the desired portions of [`main.sh`](http://bash3boilerplate.sh/main.sh) into your own script.
1. Download [`main.sh`](http://bash3boilerplate.sh/main.sh) and start pressing the delete-key to remove unwanted things

Once the `main.sh` has been tailor-made for your project, you can either append your own script in the same file, or source it in the following ways:

1. Copy [`main.sh`](http://bash3boilerplate.sh/main.sh) into the same directory as your script and then edit and embed it into your script using Bash's `source` include feature, e.g.:

```bash
#!/usr/bin/env bash
source main.sh
```

1. Source [`main.sh`](http://bash3boilerplate.sh/main.sh) in your script or at the command line:

```bash
#!/usr/bin/env bash
source main.sh
```

## How do I add a command-line flag?

1. Copy the line from the `main.sh` [read block](https://github.com/kvz/bash3boilerplate/blob/v2.1.0/main.sh#L109-L115) that most resembles the desired behavior and paste the line into the same block.
1. Edit the single-character (e.g., `-d`) and, if present, the multi-character (e.g., `--debug`) versions of the flag in the copied line.
1. Omit the `[arg]` text in the copied line, if the desired flag takes no arguments.
1. Omit or edit the text after `Default=` to set or not set default values, respectively.
1. Omit the `Required.` text, if the flag is optional.

## How do I access the value of a command-line argument?

To find out the value of an argument, append the corresponding single-character flag to the text `$arg_`.  For example, if the [read block]
contains the line

```bash
   -t --temp  [arg] Location of tempfile. Default="/tmp/bar"
```

then you can evaluate the corresponding argument and assign it to a variable as follows:

```bash
__temp_file_name="${arg_t}"
```

## What is a magic variable?

The [magic variables](https://github.com/kvz/bash3boilerplate/blob/v2.1.0/main.sh#L26-L28) in `main.sh` are special in that they have a different value, depending on your environment. You can use `${__file}` to get a reference to your current script, and `${__dir}` to get a reference to the directory it lives in. This is not to be confused with the location of the calling script that might be sourcing the `${__file}`, which is accessible via `${0}`, or the current directory of the administrator running the script, accessible via `$(pwd)`.

## How do I submit an issue report?

Please visit our [Issues](https://github.com/krisztianmukli/bash3boilerplate/issues) page.

## How can I contribute to this project?

Please fork this repository.  After that, create a branch containing your suggested changes and submit a pull request based on the master branch
of <https://github.com/kvz/bash3boilerplate/>. We are always more than happy to accept your contributions!

## Why are you typing BASH in all caps?

As an acronym, Bash stands for Bourne-again shell, and is usually written with one uppercase.
This project's name, however, is "BASH3 Boilerplate by krisztianmukli". It is a reference to
"[HTML5 Boilerplate](https://html5boilerplate.com/)", which was founded to serve a similar purpose,
only for crafting webpages and myself (Krisztian Mukli), who customized the 
original BASH3 Boilerplate project.
Somewhat inconsistent – but true to Unix ancestry – the abbreviation for our project is "b3bp".

## You are saying you are portable, but why won't b3bp code run in dash / busybox / posh / ksh / mksh / zsh?

When we say _portable_, we mean across Bash versions. Bash is widespread and most systems
offer at least version 3 of it. Make sure you have that available and b3bp will work for you.

This portability, however, does not mean that we try to be compatible with
KornShell, Zsh, posh, yash, dash, or other shells. We allow syntax that would explode if
you pasted it in anything but Bash 3 and up.

## How do I do Operating System detection?

We are creating an os_detection.sh modul, which is simply sourcable when it needs.
This library is combined methods of [this stackoverflow post](http://stackoverflow.com/a/8597411/151666) and [Phoronix Test Suite](https://github.com/phoronix-test-suite/phoronix-test-suite/blob/master/phoronix-test-suite)'s OS-detection. 

Firstly use OSTYPE variable, available in Bash, then searching for default 
package-managers of the common distros. It is not capable of determining the exact
name of the OS, but it can find family of the distro which is using. 
It will add a variable, called DISTROTYPE, which contains family of the OS, such as
'debian-based', 'redhat/fedora-based', etc. You can test OSTYPE and DISTROTYPE
when you need that information.

```bash
if [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE}" = "debian-based" ]]; then
  echo "Debian-based system used"
elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE}" = "suse-based" ]]; then
  echo "openSUSE-based system used"
elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE}" = "fedora-based" ]]; then
  echo "Fedora-based system used"
elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE}" = "redhat-based" ]]; then
  echo "Red Hat-based system used"
...
fi
```

## How do I access a potentially unset (environment) variable?

The set -o nounset line in `main.sh` causes error termination when an unset environment variables is detected as unbound. There are multiple ways to avoid this.

Some code to illustrate:

```bash
# method 1
echo ${NAME1:-Damian} # echos Damian, $NAME1 is still unset
# method 2
echo ${NAME2:=Damian} # echos Damian, $NAME2 is set to Damian
# method 3
NAME3=${NAME3:-Damian}; echo ${NAME3} # echos Damian, $NAME3 is set to Damian
```

This subject is briefly touched on as well in the [Safety and Portability section under point 5](README.md#safety-and-portability). b3bp currently uses method 1 when we want to access a variable that could be undeclared, and method 3 when we also want to set a default to an undeclared variable, because we feel it is more readable than method 2. We feel `:=` is easily overlooked, and not very beginner friendly. Method 3 seems more explicit in that regard in our humble opinion.

## How can I detect or trap Ctrl-C and other signals?

You can trap [Unix signals](https://en.wikipedia.org/wiki/Unix_signal) like [Ctrl-C](https://en.wikipedia.org/wiki/Control-C) with code similar to:

```bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C"
}
```

See http://mywiki.wooledge.org/SignalTrap for a list of signals, examples, and an in depth discussion.

## How can I get the PID of my running script?

The PID of a running script is contained in the `${$}` variable. This is *not* the pid of any subshells. With Bash 4 you can get the PID of your subshell with `${BASHPID}`. For a comprehensive list of Bash built in variables see, e.g., http://www.tldp.org/LDP/abs/html/internalvariables.html
