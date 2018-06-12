#!/usr/bin/env bash
# Operating System Detection based on OSTYPE and the package manager
# Based on following sources:
# * https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script/8597411#8597411
# * https://github.com/dylanaraps/neofetch/issues/433
# * https://gist.github.com/marcusandre/4b88c2428220ea255b83
# * https://github.com/phoronix-test-suite/phoronix-test-suite/blob/master/phoronix-test-suite
# NOT TESTED IN EVERY CASE!!

function install_cmd(){
local force="${1:-}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then 
    if [[ -x /usr/bin/zypper ]]; then [[ "${force}" = "0" ]] && echo "zypper install" || echo "zypper install --non-interactive"; # SUSE / openSUSE
    elif [[ -x /usr/bin/apt-get ]]; then [[ "${force}" = "0" ]] && echo "apt-get install" || echo "apt-get install --yes"; # Debian / Ubuntu Based Systems
    elif [[ -x /usr/bin/dnf ]]; then [[ "${force}" = "0" ]] && echo "dnf install" || echo "dnf install --assumeyes"; # Modern Fedora and derivatives
    elif [[ -x /usr/bin/yum ]]; then [[ "${force}" = "0" ]] && echo "yum install" || echo "yum install -y"; # Red Hat / Fedora or derivatives
    elif [[ -x /usr/bin/pacman ]]; then [[ "${force}" = "0" ]] && echo "pacman -S" || echo "pacman -S --noconfirm"; # Arch Linux or derivates
    elif [[ -x /usr/local/swupd ]]; then echo "swupd bundle-add" ; # Clear Linux
    elif [[ -x /usr/sbin/equo ]]; then [[ "${force}" = "0" ]] && echo "equo install --ask" || echo "equo install"; # Sabayon
    elif [[ -x /usr/bin/xbps-install ]] || [[ -x /usr/sbin/xbps-install ]]; then echo "xbps-install -S" ; # Void Linux
    elif [[ -x /usr/sbin/netpkg ]]; then echo "netpkg" ; # Zenwalk / Slackware
    elif [[ -x /sbin/apk ]]; then echo "apk add"; # Alpine Linux
    elif [[ -x /usr/bin/urpmi ]]; then [[ "${force}" = "0" ]] && echo "urpmi" || echo "urpmi --force"; # OpenMandriva Linux
    elif [[ -x /usr/bin/eopkg ]]; then [[ "${force}" = "0" ]] && echo "eopkg install" || echo "eopkg install --yes-all"; # Solus Linux
    elif [[ -x /bin/opkg ]]; then echo "opkg install"; # OpenWRT and LEDE
    elif [[ -x /usr/bin/emerge ]]; then echo "emerge"; # Gentoo
    fi
  elif [[ "$OSTYPE" == "linux-android" ]]; then echo "pkg install"; # Android (termux)
  elif [[ "$OSTYPE" == "darwin"* ]]; then echo "brew install"; # Mac OSX, requires Homebrew, TODO: check and install homebrew if it is necessary
  elif [[ "$OSTYPE" == "cygwin" ]]; then echo "apt-cyg install"; # POSIX compatibility layer and Linux environment emulation for Windows, requires apt-cyg,TODO: check and install apt-cyg if it is necessary https://github.com/transcode-open/apt-cyg
  elif [[ "$OSTYPE" == "msys" ]] && [[ -x /usr/bin/pacman ]]; then echo "pacman -S"; # MSYS2 software distro and building platform for Windows
  elif [[ "$OSTYPE" == "msys" ]]; then echo "mingw-get install"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW), TODO: check and install mingw-get if it is necessary
  elif [[ "$OSTYPE" == "win32" ]]; then echo "unknown"; # I'm not sure this can happen.
  elif [[ "$OSTYPE" == "freebsd"* ]]; then echo "pkg_add -r"; # FreeBSD
  elif [[ "$OSTYPE" == "openbsd"* ]]; then echo "pkg_add"; # OpenBSD # if [[ -x /usr/sbin/pkg_add ]]; then DISTROTYPE="openbsd"; fi # OpenBSD
  elif [[ "$OSTYPE" == "netbsd"* ]]; then echo "pkg_add"; # NetBSD
  elif [[ -x /usr/bin/pkg_radd ]]; then echo "pkg_radd"; # BSD
  elif [[ -x /usr/local/sbin/pkg ]] || [[ -x /usr/sbin/pkg ]]; then echo "pkg install"; # DragonFlyBSD
  elif [[ -x /usr/sbin/mport ]]; then echo "mport install"; # MidnightBSD  
  else echo ""; # Unknown operating system
  fi
  
}

function install_pkgs(){
local pkgs="${1:-}"
local force="${2:-}"
local installcmd=$( install_cmd "${force}" )
local root=$( [[ $EUID != 0 ]] && echo "sudo" || echo "" )
  
  if [[ ! -z "${pkgs}" ]] && [[ ! -z "${installcmd}" ]]; then
    if [[ $EUID != 0 ]]; then
      eval "sudo ${installcmd} ${pkgs}"
    else
      eval "${installcmd} ${pkgs}"
    fi
  fi

  return $?
  
}

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
  elif [[ -x /bin/opkg ]]; then DISTROTYPE="openwrt"; # OpenWRT and LEDE
  elif [[ -x /usr/bin/emerge ]]; then DISTROTYPE="gentoo"; # Gentoo
  fi
elif [[ "$OSTYPE" == "linux-android" ]]; then DISTROTYPE="android-termux"; # Android (termux)
elif [[ "$OSTYPE" == "darwin"* ]]; then DISTROTYPE="macosx"; # Mac OSX
elif [[ "$OSTYPE" == "cygwin" ]]; then DISTROTYPE="cygwin"; # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]] && [[ -x /usr/bin/pacman ]]; then DISTROTYPE="msys2"; # MSYS2 software distro and building platform for Windows
elif [[ "$OSTYPE" == "msys" ]]; then DISTROTYPE="msys"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then DISTROTYPE="win32"; # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then DISTROTYPE="freebsd"; # FreeBSD
elif [[ "$OSTYPE" == "openbsd"* ]]; then DISTROTYPE="openbsd"; # OpenBSD # if [[ -x /usr/sbin/pkg_add ]]; then DISTROTYPE="openbsd"; fi # OpenBSD
elif [[ "$OSTYPE" == "netbsd"* ]]; then DISTROTYPE="netbsd"; # NetBSD
elif [[ -x /usr/bin/pkg_radd ]]; then DISTROTYPE="bsd"; # BSD
elif [[ -x /usr/local/sbin/pkg ]] || [[ -x /usr/sbin/pkg ]]; then DISTROTYPE="dragonflybsd"; # DragonFlyBSD
elif [[ -x /usr/sbin/mport ]]; then DISTROTYPE="midnightbsd"; # MidnightBSD  
else DISTROTYPE="unknown" # Unknown operating system
fi

export DISTROTYPE
