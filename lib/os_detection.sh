#!/usr/bin/env bash
#===============================================================================
# OS Detection (os_detection.sh)
#
# Operating System Detection based on OSTYPE and the package manager
# Based on following sources:
# * https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script/8597411#8597411
# * https://github.com/dylanaraps/neofetch/issues/433
# * https://gist.github.com/marcusandre/4b88c2428220ea255b83
# * https://github.com/phoronix-test-suite/phoronix-test-suite/blob/master/phoronix-test-suite
#
# The MIT License (MIT)
# Copyright (c) 2018 Krisztián Mukli
# https://www.github.com/krisztianmukli/bash3boilerplate
#
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.
#
# Notes
#-------------------------------------------------------------------------------
# Quickstart
# * Sourcing this file, it is add and set the DISTROTYPE variable, then you can
# test it against OSTYPE AND DISTROTYPE for the proper OS.
#
# Setup information
# Changelog
# ToDo
# Known bugs and limitations
# * NOT TESTED IN EVERY CASE!!
#
# Based on BASH4 Boilerplate 20170818-dev and BASH3 Boilerplate v2.3.0
#===============================================================================
# Main section
#===============================================================================
if [[ "$OSTYPE" == "linux-gnu" ]]; then 
  if [[ -x /usr/bin/zypper ]]; then DISTROTYPE="suse-based"; # SUSE / openSUSE
  elif [[ -x /usr/bin/apt-get ]]; then DISTROTYPE="debian-based"; # Debian / Ubuntu Based Systems
  elif [[ -x /usr/bin/dnf ]]; then DISTROTYPE="fedora-based"; # Modern Fedora and derivatives
  elif [[ -x /usr/bin/yum ]]; then DISTROTYPE="redhat-based"; # Red Hat / Fedora or derivatives
  elif [[ -x /usr/bin/pacman ]]; then DISTROTYPE="arch-based"; # Arch Linux or derivates
  elif [[ -x /usr/local/swupd ]]; then DISTROTYPE="clearlinux"; # Clear Linux
  elif [[ -x /usr/sbin/equo ]]; then DISTROTYPE="sabayon"; # Sabayon
  elif [[ -x /usr/bin/xbps-install ]] || [[ -x /usr/sbin/xbps-install ]]; then DISTROTYPE="voidlinux"; # Void Linux
  elif [[ -x /usr/sbin/netpkg ]]; then DISTROTYPE="slackware"; # Zenwalk / Slackware
  elif [[ -x /sbin/apk ]]; then DISTROTYPE="alpinelinux"; # Alpine Linux
  elif [[ -x /usr/bin/urpmi ]]; then DISTROTYPE="openmandriva"; # OpenMandriva Linux
  elif [[ -x /usr/bin/eopkg ]]; then DISTROTYPE="soluslinux"; # Solus Linux
  elif [[ -x /bin/opkg ]]; then DISTROTYPE="openwrt"; # OpenWRT and Linux Embedded Development Environment
  elif [[ -x /usr/bin/emerge ]]; then DISTROTYPE="gentoo"; # Gentoo
  fi
elif [[ "$OSTYPE" == "linux-android" ]]; then DISTROTYPE="android-termux"; # Android (termux)
elif [[ "$OSTYPE" == "darwin"* ]]; then DISTROTYPE="macosx"; # Mac OSX
elif [[ "$OSTYPE" == "cygwin" ]]; then DISTROTYPE="windows-cygwin"; # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then DISTROTYPE="windows-mingw"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then DISTROTYPE="windows-win32"; # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then DISTROTYPE="freebsd"; # FreeBSD
elif [[ "$OSTYPE" == "openbsd"* ]]; then DISTROTYPE="openbsd"; # OpenBSD # if [[ -x /usr/sbin/pkg_add ]]; then DISTROTYPE="openbsd"; fi # OpenBSD
elif [[ "$OSTYPE" == "netbsd"* ]]; then DISTROTYPE="netbsd"; # NetBSD
elif [[ -x /usr/bin/pkg_radd ]]; then DISTROTYPE="bsd"; # BSD
elif [[ -x /usr/local/sbin/pkg ]] || [[ -x /usr/sbin/pkg ]]; then DISTROTYPE="dragonflybsd"; # DragonFlyBSD
elif [[ -x /usr/sbin/mport ]]; then DISTROTYPE="midnightbsd"; # MidnightBSD  
else DISTROTYPE="unknown" # Unknown operating system
fi

export DISTROTYPE

#===============================================================================
# END OF FILE
#===============================================================================
