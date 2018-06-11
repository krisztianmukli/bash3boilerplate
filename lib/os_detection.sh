#!/usr/bin/env bash
# Operating System Detection based on OSTYPE and the package manager
# Based on following sources:
# * https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script/8597411#8597411
# * https://github.com/dylanaraps/neofetch/issues/433
# * https://gist.github.com/marcusandre/4b88c2428220ea255b83
# * https://github.com/phoronix-test-suite/phoronix-test-suite/blob/master/phoronix-test-suite
# NOT TESTED IN EVERY CASE!!

function forcearg(){
local installcmd="${1:-}"
local force="${2:-}"

  if [[ "${installcmd:-}" = "zypper"* ]]; then echo "--non-interactive"; # Zypper
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "dnf"* ]]; then echo "--assumeyes"; # Dnf
  elif [[ "${installcmd:-}" = "yum"* ]]; then echo "-y"; # Yum
  elif [[ "${installcmd:-}" = "pacman"* ]]; then echo "--noconfirm"; # Pacman
  elif [[ "${installcmd:-}" = "equo"* ]]; then echo "--ask"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  elif [[ "${installcmd:-}" = "apt-get"* ]]; then echo "--yes"; # Apt-get
  else
      echo "" #unknown or not support force mode
  fi

}

function installcmd(){

  if [[ "$OSTYPE" == "linux-gnu" ]]; then 
    if [[ -x /usr/bin/zypper ]]; then echo "zypper install"; # SUSE / openSUSE
    elif [[ -x /usr/bin/apt-get ]]; then echo "apt-get install"; # Debian / Ubuntu Based Systems
    elif [[ -x /usr/bin/dnf ]]; then echo "dnf install"; # Modern Fedora and derivatives
    elif [[ -x /usr/bin/yum ]]; then echo "yum install"; # Red Hat / Fedora or derivatives
    elif [[ -x /usr/bin/pacman ]]; then echo "pacman -S"; # Arch Linux or derivates
    elif [[ -x /usr/local/swupd ]]; then echo "swupd bundle-add" ; # Clear Linux
    elif [[ -x /usr/sbin/equo ]]; then echo "equo install"; # Sabayon
    elif [[ -x /usr/bin/xbps-install ]] || [[ -x /usr/sbin/xbps-install ]]; then echo "xbps-install -S" ; # Void Linux
    elif [[ -x /usr/sbin/netpkg ]]; then echo "netpkg" ; # Zenwalk / Slackware
    elif [[ -x /sbin/apk ]]; then echo "apk add"; # Alpine Linux
    elif [[ -x /usr/bin/urpmi ]]; then echo "urpmi"; # OpenMandriva Linux
    elif [[ -x /usr/bin/eopkg ]]; then echo "eopkg install"; # Solus Linux
    elif [[ -x /bin/opkg ]]; then echo "opkg install"; # OpenWRT and LEDE
    elif [[ -x /usr/bin/emerge ]]; then echo "emerge"; # Gentoo
    fi
  elif [[ "$OSTYPE" == "linux-android" ]]; then echo "pkg install"; # Android (termux)
  elif [[ "$OSTYPE" == "darwin"* ]]; then echo "brew install"; # Mac OSX, requires Homebrew, TODO: check and install homebrew if it is necessary
  elif [[ "$OSTYPE" == "cygwin" ]]; then echo "apt-cyg install"; # POSIX compatibility layer and Linux environment emulation for Windows, requires apt-cyg,TODO: check and install apt-cyg if it is necessary https://github.com/transcode-open/apt-cyg
  elif [[ "$OSTYPE" == "msys" ]]; then  # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    if [[ -x /usr/bin/pacman ]]; then 
        echo "pacman -S"; # MSYS2 software distro and building platform for Windows
    else
        echo "mingw-get install"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW), TODO: check and install mingw-get if it is necessary
    fi
  elif [[ "$OSTYPE" == "win32" ]]; then echo "unknown"; # I'm not sure this can happen.
  elif [[ "$OSTYPE" == "freebsd"* ]]; then echo "pkg_add -r"; # FreeBSD
  elif [[ "$OSTYPE" == "openbsd"* ]]; then echo "pkg_add"; # OpenBSD # if [[ -x /usr/sbin/pkg_add ]]; then DISTROTYPE="openbsd"; fi # OpenBSD
  elif [[ "$OSTYPE" == "netbsd"* ]]; then echo "pkg_add"; # NetBSD
  elif [[ -x /usr/bin/pkg_radd ]]; then echo "pkg_radd"; # BSD
  elif [[ -x /usr/local/sbin/pkg ]] || [[ -x /usr/sbin/pkg ]]; then echo "pkg install"; # DragonFlyBSD
  elif [[ -x /usr/sbin/mport ]]; then echo "mport install"; # MidnightBSD  
  else DISTROTYPE="unknown" # Unknown operating system
  fi
  
}

function checkcmd(){
# Check OS and set OS-specific folders and commands
  if [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "suse-based" ]]; then
    
    [[ "${1:?}" = "1" ]] && echo "zypper install --non-interactive"
    echo "zypper install"

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "debian-based" ]]; then

    [[ "${1:?}" = "1" ]] && echo "apt-get install --yes"
    echo "apt-get install"

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "fedora-based" ]]; then

    [[ "${1:?}" = "1" ]] && echo "dnf install --assumeyes"
    echo "dnf install"

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "redhat-based" ]]; then

    [[ "${1:?}" = "1" ]] && echo "yum install -y"
    echo "yum install"

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "arch-based" ]]; then

    [[ "${1:?}" = "1" ]] && echo "pacman -S --noconfirm"
    echo "pacman -S"

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "clearlinux" ]]; then

    echo "swupd bundle-add" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "sabayon" ]]; then

    [[ "${1:?}" = "1" ]] && echo "equo install" # reverse force
    echo "equo install --ask" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "voidlinux" ]]; then

    echo "xbps-install -S" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "slackware" ]]; then

    echo "netpkg" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "alpinelinux" ]]; then

    echo "apk add" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "openmandriva" ]]; then

    [[ "${1:?}" = "1" ]] && echo "urpmi --force"
    echo "urpmi" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "soluslinux" ]]; then

    [[ "${1:?}" = "1" ]] && echo "eopkg install --yes-all"
    echo "eopkg install" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "openwrt" ]]; then

    echo "opkg install" 

  elif [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "gentoo" ]]; then
    
    echo "emerge"

  # Unsupported OS
  else
    # display_info exit 1
    display_info $"Unsupported operating system." $"Install script manually: 
    * Copy the script and the lib folder to your PATH.
    * Copy to locale folder to your locale folder."
  fi
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
elif [[ "$OSTYPE" == "cygwin" ]]; then DISTROTYPE="windows-cygwin"; # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then 
  if [[ -x /usr/bin/pacman ]]; then 
      DISTROTYPE="windows-msys2"; # MSYS2 software distro and building platform for Windows
  else
      DISTROTYPE="windows-mingw"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  fi
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
