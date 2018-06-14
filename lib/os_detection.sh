#!/usr/bin/env bash
# Operating System Detection based on OSTYPE and the package manager
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
# NOT TESTED IN EVERY CASE!!
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
__ostype="${OSTYPE:-unknown}" # $OSTYPE is simpler than uname -s
__osfamily="unknown"
__osname="unknown"
__osversion="unknown"
__kernelversion=$(uname -r)
__arch=$(uname -m)
#-------------------------------------------------------------------------------
# Linux
#-------------------------------------------------------------------------------
if [[ "${__ostype}" = "linux-gnu" ]]; then
#-------------------------------------------------------------------------------
# Determine OS Family by package manager
#-------------------------------------------------------------------------------
  if [[ -x /usr/bin/zypper ]]; then __osfamily="suse-based"; # SUSE / openSUSE
  elif [[ -x /usr/bin/apt-get ]]; then __osfamily="debian-based"; # Debian / Ubuntu Based Systems
  elif [[ -x /usr/bin/dnf ]]; then __osfamily="fedora-based"; # Modern Fedora and derivatives
  elif [[ -x /usr/bin/yum ]]; then __osfamily="redhat-based"; # Red Hat / Fedora or derivatives
  elif [[ -x /usr/bin/pacman ]]; then __osfamily="arch-based"; # Arch Linux or derivates
  elif [[ -x /usr/local/swupd ]]; then __osfamily="clearlinux"; # Clear Linux
  elif [[ -x /usr/sbin/equo ]]; then __osfamily="sabayon"; # Sabayon
  elif [[ -x /usr/bin/xbps-install ]] || [[ -x /usr/sbin/xbps-install ]]; then __osfamily="voidlinux"; # Void Linux
  elif [[ -x /usr/sbin/netpkg ]]; then __osfamily="slackware"; # Zenwalk / Slackware
  elif [[ -x /sbin/apk ]]; then __osfamily="alpinelinux"; # Alpine Linux
  elif [[ -x /usr/bin/urpmi ]]; then __osfamily="openmandriva"; # OpenMandriva Linux
  elif [[ -x /usr/bin/eopkg ]]; then __osfamily="soluslinux"; # Solus Linux
  elif [[ -x /bin/opkg ]]; then __osfamily="openwrt"; # OpenWRT and LEDE
  elif [[ -x /usr/bin/emerge ]]; then __osfamily="gentoo"; # Gentoo
  fi
#-------------------------------------------------------------------------------
# Determine OS Name by /etc/os-release
#-------------------------------------------------------------------------------
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release; 
    
    # Scientific Linux and older Fedora use 'rhel' as ID
    if [[ "${ID}" = "rhel" ]]; then 
      # Check /etc/redhat-release file
      if [[ -f /etc/redhat-release ]]; then
        __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/redhat-release)
        if [[ "${__tmp_id}" = *"red hat"* ]]; then __osname="redhat";
        elif [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
        elif [[ "${__tmp_id}" = *"fedora"* ]]; then __osname="fedora";
        # Get words before 'release' and replace spaces to dash
        else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g);
        fi
        unset -v __tmp_id
      # Check lsb_release command
      elif type lsb_release >/dev/null 2>&1; then
        __osname=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
      # Check /etc/lsb-release file
      elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        __osname=$(echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]') 
      fi
    else
      # Otherwise use ID variable as distro
      __osname="${ID}";
    fi

    # Debian's os-release file doesn't include a version or version_id.
    if [[ "${__osname}" = "debian" ]]; then
      # version detection falls through to the "legacy" method of reading from /etc/debian_version
      if [[ -f /etc/debian_version ]]; then read __osversion < /etc/debian_version;
      # if no debian_version file, check lsb_release command
      elif type lsb_release >/dev/null 2>&1; then __osversion=$(lsb_release -sr);
      # There are any chance, that have /etc/lsb-release file, without lsb_release command
      elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        __osversion="${DISTRIB_RELEASE}"
      fi
    # Arch's os-release file doesn't include a version or version_id.
    elif [[ "${__osname}" = "arch" ]]; then
      __osversion="rolling"
    else
      # Use VERSION_ID as release
      __osversion="${VERSION_ID}"
    fi
#-------------------------------------------------------------------------------
# Determine OS Name by lsb_release
#-------------------------------------------------------------------------------
  elif type lsb_release >/dev/null 2>&1; then
    __osname=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    __osversion=$(lsb_release -sr)
    if [[ "${__osname}" = "amazonami" ]]; then __osname="amzn";
    elif [[ "${__osname}" = "opensuse project" ]]; then __osname="opensuse";
    elif [[ "${__osname}" = "suse linux" ]]; then __osname="sles"; 
    fi
#-------------------------------------------------------------------------------
# Determine OS Name by /etc/lsb-release
#-------------------------------------------------------------------------------
  elif [[ -f /etc/lsb-release ]]; then
    source /etc/lsb-release
    __osname=$(echo "${DISTRIB_ID}" | tr '[:upper:]' '[:lower:]')
    __osversion="${DISTRIB_ID}"
    if [[ "${__osname}" = "amazonami" ]]; then __osname="amzn";
    elif [[ "${__osname}" = "opensuse project" ]]; then __osname="opensuse";
    elif [[ "${__osname}" = "suse linux" ]]; then __osname="sles"; 
    fi
#-------------------------------------------------------------------------------
# Determine OS Name by /etc/*-release
#-------------------------------------------------------------------------------
  elif [[ -f /etc/centos-release ]]; then # CentOS
    __osname="centos"; 
    __osversion=$(sed 's/.*release\ //' /etc/centos-release | sed 's/\ .*//')
  elif [[ -f /etc/fedora-release ]]; then # Fedora
    __osname="fedora"; 
    __osversion=$(sed 's/.*release\ //' /etc/fedora-release | sed 's/\ .*//')
  elif [[ -f /etc/redhat-release ]]; then # Red Hat and derivaties
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/redhat-release)
    __osversion=$(sed 's/.*release\ //' /etc/redhat-release | sed 's/\ .*//')
    if [[ "${__tmp_id}" = *"red hat"* ]]; then __osname="redhat";
    elif [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    elif [[ "${__tmp_id}" = *"fedora"* ]]; then __osname="fedora";
    # Get words before 'release' and replaces spaces to dash
    else __osname=$(echo "${__tmp_id}" | sed 's/\ release.*//g' | sed 's/\ /-/g' | tr '[:upper:]' '[:lower:]'); 
    fi
    unset -v __tmp_id
  elif [[ -f /etc/SuSE-release ]]; then # SuSE and derivates
    __tmp_id=$(tr "\n" ' ' < /etc/SuSE-release | sed 's/VERSION.*//' | tr '[:upper:]' '[:lower:]');
    __osversion=$(grep VERSION /etc/SuSE-release | sed 's/VERSION\ *=\ *//')
    if [[ "${__tmp_id}" = *"suse linux"* ]]; then __osname="sles";
    elif [[ "${__tmp_id}" = *"opensuse"* ]]; then __osname="opensuse";
    # Get words and replaces spaces to dash
    else __osname=$(echo "${__tmp_id}" | sed 's/\ /-/g' | tr '[:upper:]' '[:lower:]'); 
    fi
    unset -v __tmp_id
  elif [[ -f /etc/system-release ]]; then
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/system-release)
    __osversion=$(sed 's/.*release\ //' /etc/system-release | sed 's/\ .*//')
    if [[ "${__tmp_id}" = *"amazon"* ]]; then __osname="amzn";
    elif [[ "${__tmp_id}" = *"centos"* ]]; then __osname="centos";
    elif [[ "${__tmp_id}" = *"fedora"* ]]; then __osname="fedora";
    elif [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    # Get words before 'release' and replaces spaces to dash
    else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g | tr '[:upper:]' '[:lower:]');
    fi
    unset -v __tmp_id
  elif [[ -f /etc/sl-release ]]; then read __osname < /etc/sl-release; # Older Scientific Linux
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/sl-release)
    __osversion=$(sed 's/.*release\ //' /etc/sl-release | sed s/\ .*//)
    if [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    # Get words before 'release' and replaces spaces to dash
    else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g | tr '[:upper:]' '[:lower:]');
    fi
    unset -v __tmp_id
#-------------------------------------------------------------------------------
# Determine OS Name by legacy distro-specific files
#-------------------------------------------------------------------------------
  elif [[ -f /etc/arch-version ]]; then 
    __osname="arch"
    __osversion="rolling"
  elif [[ -f /etc/slackware-version ]]; then 
    __osname=$(tr '[:upper:]' '[:lower:]' < /etc/slackware-version | sed s/\ [0-9.-\(\)]*//g)
    __osversion=$(sed 's/.* \([0-9][0-9A-Za-z_-\.]*\).*/\1/' /etc/slackware-version)
  elif [[ -f /etc/debian_version ]]; then
    __osname="debian"
    read __osversion < /etc/debian_version
#-------------------------------------------------------------------------------
# Android
#-------------------------------------------------------------------------------
  elif [[ -e /system/bin/adb ]]; then # Android-device, https://gist.github.com/enten/67c4e332908b248a59a9
    __osname="android"
    __osversion=$(uname -r) # I'm not sure it is working
  fi
#-------------------------------------------------------------------------------
# Android-Termux
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" == "linux-android" ]]; then # Android (termux)
  __osfamily="android-termux"
  __osname="android"
#-------------------------------------------------------------------------------
# Solaris
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" = "solaris" ]]; then
  __osfamily="solaris"
  __osversion=$(uname -v)
  if [[ "${__osversion}" = "joyent_"* ]]; then # SmartOS
    __osname="smartos"
  elif [[ "${__osversion}" = "oi_"* ]]; then # OpenIndiana
    __osname="openindiana"
  elif [[ "${__osversion}" = "omnios-"* ]]; then # OmniOS
    __osname="omnios"
    [[ -f /etc/release ]] && __osversion=$(head -1 /etc/release | awk '{print $NF}')
  elif [[ "${__osversion}" = "NexentaOS_"* ]]; then # NexentaStor
    __osname="nexentastor"
    [[ -f /etc/release ]] && __osversion=$(head -1 /etc/release | awk '{print $NF}' | tr -d v)
  elif [[ "${__osversion}" = "Generic"* ]]; then # Solaris and some illumos distributions
    if [[ -f /etc/release ]] && grep "Solaris" >/dev/null 2>/dev/null < /etc/release; then
      __osname="solaris"
      __osversion=$(uname -r | cut -d. -f2)
    else
      __osname="generic"
    fi
  fi
#-------------------------------------------------------------------------------
# Other Unix
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" == "darwin"* ]]; then # macOS
  __osfamily="darwin"
  __osname="macos"
  __osversion=$(sw_vers -productVersion)
elif [[ "${__ostype}" == "freebsd"* ]]; then # FreeBSD
  __osfamily="bsd"; 
  __osname="freebsd"
  __osversion=$(freebsd-version -u)
elif [[ "${__ostype}" == "openbsd"* ]]; then # OpenBSD 
  __osfamily="bsd"
  __osname="openbsd"
  __osversion=$(uname -r)
elif [[ "${__ostype}" == "netbsd"* ]]; then # NetBSD
  __osfamily="bsd"
  __osname="netbsd"
  __osversion=$(uname -r)
elif [[ "${__ostype}" = "dragonfly"* ]]; then # DragonFlyBSD
  __osfamily="bsd"
  __osname="dragonflybsd"
  __osversion=$(uname -r)
elif [[ -x /usr/local/sbin/pkg ]] || [[ -x /usr/sbin/pkg ]]; then # DragonFlyBSD, legacy method
  __osfamily="bsd"
  __osname="dragonflybsd"
  __osversion=$(uname -r) 
elif [[ -x /usr/sbin/mport ]]; then # MidnightBSD
  __osfamily="bsd";
  __osname="midnightbsd"
  __osversion=$(uname -r) 
elif [[ -x /usr/bin/pkg_radd ]]; then # Generic BSD
  __osfamily="bsd";
  __osname=$(uname -s)
  __osversion=$(uname -r)
#-------------------------------------------------------------------------------
# Windows
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" == "cygwin" ]]; then # POSIX compatibility layer and Linux environment emulation for Windows
  __osfamily="cygwin"
  __osname=$(systeminfo | sed -n 's/^OS Name:[[:blank:]]*//p') 
  if [[ "${__osname}" = *"Windows Vista"* ]]; then __osname="vista";
  elif [[ "${__osname}" = *"Windows 7"* ]]; then __osname="win7";
  elif [[ "${__osname}" = *"Windows 8.1"* ]]; then __osname="win81";
  elif [[ "${__osname}" = *"Windows 8"* ]]; then __osname="win8";
  elif [[ "${__osname}" = *"Windows 10"* ]]; then __osname="win10";
  elif [[ "${__osname}" = *"Windows Server 2008 R2"* ]]; then __osname="server2008r2";
  elif [[ "${__osname}" = *"Windows Server 2008"* ]]; then __osname="server2008";
  elif [[ "${__osname}" = *"Windows Server 2012 R2"* ]]; then __osname="server2012r2";
  elif [[ "${__osname}" = *"Windows Server 2012"* ]]; then __osname="server2012";
  elif [[ "${__osname}" = *"Windows Server 2016"* ]]; then __osname="server2016";
  elif [[ "${__osname}" = *"Windows Server 2019"* ]]; then __osname="server2019";
  fi
  __osversion=$(systeminfo | sed -n 's/^OS Version:[[:blank:]]*//p'| awk '{print $1;}')
elif [[ "${__ostype}" == "msys" ]] && [[ -x /usr/bin/pacman ]]; then __osfamily="msys2"; # MSYS2 software distro and building platform for Windows
elif [[ "${__ostype}" == "msys" ]]; then __osfamily="msys"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "${__ostype}" == "win32" ]]; then __osfamily="win32"; # I'm not sure this can happen.
#-------------------------------------------------------------------------------
# Other non-unix
#-------------------------------------------------------------------------------
elif [[ "${__ostype}" == "haiku" ]]; then # Haiku
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
