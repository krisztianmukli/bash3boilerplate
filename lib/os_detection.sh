#!/usr/bin/env bash
# Operating System Detection based on uname, $OSTYPE and the package manager
# Based on following sources:
# * https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script/8597411#8597411
# * https://github.com/dylanaraps/neofetch/issues/433
# * https://gist.github.com/marcusandre/4b88c2428220ea255b83
# * https://github.com/phoronix-test-suite/phoronix-test-suite/blob/master/phoronix-test-suite
# * https://gist.github.com/natefoo/814c5bf936922dad97ff
# * https://www.freedesktop.org/software/systemd/man/os-release.html
# * http://linuxmafia.com/faq/Admin/release-files.html
# * https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/lsbrelease.html
# * https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
# * https://www.novell.com/coolsolutions/feature/11251.html
# * https://gist.github.com/natefoo/7af6f3d47bb008669467
# * https://gist.github.com/enten/67c4e332908b248a59a9
# * https://en.wikipedia.org/wiki/Uname
# * https://stackoverflow.com/questions/38859145/detect-ubuntu-on-windows-vs-native-ubuntu-from-bash-script
# IT NEED MORE EXTENSIVE TEST!
#===============================================================================
# Functions section
#===============================================================================
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
  elif [[ "$OSTYPE" == "msys" ]]; then echo "mingw-get install"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
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
  
  if [[ ! -z "${pkgs}" ]] && [[ ! -z "${installcmd}" ]]; then
    if [[ $EUID != 0 ]]; then
      eval "sudo ${installcmd} ${pkgs}"
    else
      eval "${installcmd} ${pkgs}"
    fi
  fi

  return $?
  
}
#===============================================================================
# Main section
#===============================================================================
#-------------------------------------------------------------------------------
# Set initial values
#-------------------------------------------------------------------------------
__ostype=$OSTYPE
__osfamily="unknown"
__osname="unknown"
__osversion="unknown"
__kernelversion=$(uname -r) 
__arch=$HOSTTYPE
__subsystem="unknown"

#-------------------------------------------------------------------------------
# Linux
#-------------------------------------------------------------------------------
if [[ "${__ostype}" = "linux-gnu" ]]; then
#-------------------------------------------------------------------------------
# Determine __osfamily by package manager
#-------------------------------------------------------------------------------
  # most common linux distribution families
  if [[ -x /usr/bin/zypper ]]; then __osfamily="suse-based"; # SUSE / openSUSE
  elif [[ -x /usr/bin/apt-get ]]; then __osfamily="debian-based"; # Debian / Ubuntu Based Systems
  elif [[ -x /usr/bin/dnf ]]; then __osfamily="fedora-based"; # Modern Fedora and derivatives
  elif [[ -x /usr/bin/yum ]]; then __osfamily="redhat-based"; # Red Hat / Fedora or derivatives
  elif [[ -x /usr/bin/pacman ]]; then __osfamily="arch-based"; # Arch Linux or derivates
  elif [[ -x /usr/sbin/netpkg ]]; then __osfamily="slackware-based"; # Zenwalk / Slackware
  elif [[ -x /usr/bin/urpmi ]]; then __osfamily="mandriva-based"; # OpenMandriva Linux
  elif [[ -x /usr/bin/emerge ]]; then __osfamily="gentoo-based"; # Gentoo
  # independent-distributions
  elif [[ -x /usr/local/swupd ]]; then __osfamily="clearlinux"; # Clear Linux
  elif [[ -x /usr/sbin/equo ]]; then __osfamily="sabayon"; # Sabayon
  elif [[ -x /usr/bin/xbps-install ]] || [[ -x /usr/sbin/xbps-install ]]; then __osfamily="voidlinux"; # Void Linux
  elif [[ -x /sbin/apk ]]; then __osfamily="alpinelinux"; # Alpine Linux
  elif [[ -x /usr/bin/eopkg ]]; then __osfamily="soluslinux"; # Solus Linux
  elif [[ -x /bin/opkg ]]; then __osfamily="openwrt"; # OpenWRT
  fi

#-------------------------------------------------------------------------------
# Determine Linux distribution by /etc/os-release
#-------------------------------------------------------------------------------
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    __osname="${ID}"
    if [[ "${__osname}" = "debian" ]]; then __osversion=$(</etc/debian_version);
    elif [[ ! -z "${VERSION_ID}" ]] ; then __osversion="${VERSION_ID}";  
    fi
  fi

#-------------------------------------------------------------------------------
# Check if script running on Windows Subsystems for Linux
#-------------------------------------------------------------------------------
  if grep -q "Microsoft" /proc/version || grep -q "Microsoft" /proc/sys/kernel/osrelease; then
    __subsystem="wsl"
  fi

#-------------------------------------------------------------------------------
# Android (it run only with busybox, and rooted device)
#-------------------------------------------------------------------------------
  if [[  -e "/system/bin/adb" ]] && type "/system/bin/busybox" >/dev/null 2>&1; then
    __osfamily="android-based"
    __osname="android"
    __osversion=$(uname -r)
  fi
  
#-------------------------------------------------------------------------------
# Android-Termux
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" == "linux-android" ]]; then # Android (termux)
  __osfamily="android-termux"
  __osname="android"
  __osversion=$(uname -r)
  
#-------------------------------------------------------------------------------
# Solaris
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" = "solaris"* ]]; then
  __osfamily="solaris-based"
  if [[ -f /etc/release ]]; then
    if grep -q "Solaris" /etc/release ; then 
      __osname="solaris"
      __osversion=$(uname -r | cut -d. -f2)
    elif grep -q "SmartOS" /etc/release ; then 
      __osname="smartos"
      __osversion=$(uname -v)
    elif grep -q "OpenIndiana" /etc/release ; then 
      __osname="openindiana"
      __osversion=$(uname -v)
    elif grep -q "OmniOS" /etc/release ; then 
      __osname="omnios"
      __osversion=$(head -1 /etc/release | awk '{print $NF}')
    elif grep -q "Nexenta" /etc/release ; then # it could be other Nexenta distros, such as illumian
      __osname="nexentaos"
      __osversion=$(head -1 /etc/release | awk '{print $NF}' | tr -d v)
    fi
  fi

#-------------------------------------------------------------------------------
# Other Unix-like
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" = "darwin"* ]]; then # macOS
  __osfamily="darwin"
  __osname="macos"
  __osversion=$(sw_vers -productVersion)
elif [[ "${__ostype}" = "freebsd"* ]]; then # FreeBSD
  __osfamily="bsd"; 
  __osname="freebsd"
  __osversion=$(freebsd-version -u)
elif [[ "${__ostype}" = "openbsd"* ]]; then # OpenBSD 
  __osfamily="bsd"
  __osname="openbsd"
  __osversion=$(uname -r)
elif [[ "${__ostype}" = "netbsd"* ]]; then # NetBSD
  __osfamily="bsd"
  __osname="netbsd"
  __osversion=$(uname -r)
elif [[ "${__ostype}" = "dragonfly"* ]]; then # DragonFlyBSD
  __osfamily="bsd"
  __osname="dragonflybsd"
  __osversion=$(uname -r)
elif [[ "${__ostype}" = "midnightbsd" ]]; then # DragonFlyBSD
  __osfamily="bsd"
  __osname="midnightbsd"
  __osversion=$(uname -r)

#-------------------------------------------------------------------------------
# Windows
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" = "cygwin" ]] || [[ "${__ostype}" = "msys" ]]; then
  if [[ "${__ostype}" = "cygwin" ]]; then __osfamily="cygwin"; # POSIX compatibility layer and Linux environment emulation for Windows  
  elif [[ "${__ostype}" = "msys" ]] && [[ -x /usr/bin/pacman ]]; then __osfamily="msys2"; # MSYS2 software distro and building platform for Windows
  elif [[ "${__ostype}" = "msys" ]]; then __osfamily="msys"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  fi
  __ostype="windows"
  __osname=$(systeminfo | sed -n 's/^OS Name:[[:blank:]]*//p')   
  if [[ "${__osname}" = *"Windows Vista"* ]]; then __osname="vista"
  elif [[ "${__osname}" = *"Windows 7"* ]]; then __osname="win7"
  elif [[ "${__osname}" = *"Windows 8.1"* ]]; then __osname="win81"
  elif [[ "${__osname}" = *"Windows 8"* ]]; then __osname="win8"
  elif [[ "${__osname}" = *"Windows 10"* ]]; then __osname="win10"
  elif [[ "${__osname}" = *"Windows Server 2008 R2"* ]]; then __osname="winsrv2008r2"
  elif [[ "${__osname}" = *"Windows Server 2008"* ]]; then __osname="winsrv2008"
  elif [[ "${__osname}" = *"Windows Server 2012 R2"* ]]; then __osname="winsrv2012r2"
  elif [[ "${__osname}" = *"Windows Server 2012"* ]]; then __osname="winsrv2012"
  elif [[ "${__osname}" = *"Windows Server 2016"* ]]; then __osname="winsrv016"
  elif [[ "${__osname}" = *"Windows Server 2019"* ]]; then __osname="winsrv2019"
  fi
  __osversion=$(systeminfo | sed -n 's/^OS Version:[[:blank:]]*//p'| awk '{print $1;}')

#-------------------------------------------------------------------------------
# Other non-unix
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" = "haiku" ]]; then # Haiku
  __osfamily="haiku"; 
  __osname="haiku"
  __osversion=$(uname -r)
fi

export __ostype
export __osfamily
export __osname
export __osversion
export __kernelversion
export __arch
export __subsystem
