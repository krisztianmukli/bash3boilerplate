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
#-------------------------------------------------------------------------------
# Set initial values
#-------------------------------------------------------------------------------
__ostype="${OSTYPE:-unknown}"
__osfamily="unknown"
__osname="unknown"
__osversion="unknown"
__kernelversion="unknown"
__arch="unknown"
#-------------------------------------------------------------------------------
# Linux
#-------------------------------------------------------------------------------
if [[ "${__ostype}" = "linux-gnu" ]]; then
#-------------------------------------------------------------------------------
# /etc/os-release
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
        else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g); # Get words before 'release' and replaces spaces to dash
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
    if [[ "${__osname}" = "arch" ]]; then
      __osversion="rolling"
    else
      # Use VERSION_ID as release
      __osversion="${VERSION_ID}"
    fi
#-------------------------------------------------------------------------------
# lsb_release
#-------------------------------------------------------------------------------
  elif type lsb_release >/dev/null 2>&1; then
    __osname=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    __osversion=$(lsb_release -sr)
    if [[ "${__osname}" = "amazonami" ]]; then __osname="amzn";
    elif [[ "${__osname}" = "opensuse project" ]]; then __osname="opensuse";
    elif [[ "${__osname}" = "suse linux" ]]; then __osname="sles"; 
    fi
#-------------------------------------------------------------------------------
# /etc/lsb-release
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
# /etc/*-release
#-------------------------------------------------------------------------------
  elif [[ -f /etc/centos-release ]]; then # CentOS
    __osname="centos"; 
    __osversion=$(sed s/.*release\ // /etc/centos-release | sed s/\ .*//)
  elif [[ -f /etc/fedora-release ]]; then # Fedora
    __osname="fedora"; 
    __osversion=$(sed s/.*release\ // /etc/fedora-release | sed s/\ .*//)
  elif [[ -f /etc/redhat-release ]]; then # Red Hat and derivaties
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/redhat-release)
    __osversion=$(sed s/.*release\ // /etc/redhat-release | sed s/\ .*//)
    if [[ "${__tmp_id}" = *"red hat"* ]]; then __osname="redhat";
    elif [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    elif [[ "${__tmp_id}" = *"fedora"* ]]; then __osname="fedora";
    else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g); # Get words before 'release' and replaces spaces to dash
    fi
    unset -v __tmp_id
  elif [[ -f /etc/SuSE-release ]]; then # SuSE and derivates
    __tmp_id=$(tr "\n" ' ' < /etc/SuSE-release | sed s/VERSION.*// | tr '[:upper:]' '[:lower:]');
    __osversion=$(grep VERSION /etc/SuSE-release | sed s/VERSION\ *=\ *//)
    if [[ "${__tmp_id}" = *"suse linux"* ]]; then __osname="sles";
    elif [[ "${__tmp_id}" = *"opensuse"* ]]; then __osname="opensuse";
    else __osname=$(echo "${__tmp_id}" | sed s/\ /-/g); # Get words and replaces spaces to dash
    fi
    unset -v __tmp_id
  elif [[ -f /etc/system-release ]]; then
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/system-release)
    __osversion=$(sed s/.*release\ // /etc/system-release | sed s/\ .*//)
    if [[ "${__tmp_id}" = *"amazon"* ]]; then __osname="amzn";
    elif [[ "${__tmp_id}" = *"centos"* ]]; then __osname="centos";
    elif [[ "${__tmp_id}" = *"fedora"* ]]; then __osname="fedora";
    elif [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g); # Get words before 'release' and replaces spaces to dash
    fi
    unset -v __tmp_id
  elif [[ -f /etc/sl-release ]]; then read __osname < /etc/sl-release; # Older Scientific Linux
    __tmp_id=$(tr '[:upper:]' '[:lower:]' < /etc/sl-release)
    __osversion=$(sed s/.*release\ // /etc/sl-release | sed s/\ .*//)
    if [[ "${__tmp_id}" = *"scientific"* ]]; then __osname="scientific";
    else __osname=$(echo "${__tmp_id}" | sed s/\ release.*//g | sed s/\ /-/g); # Get words before 'release' and replaces spaces to dash
    fi
    unset -v __tmp_id
#-------------------------------------------------------------------------------
# legacy distro-specific files
#-------------------------------------------------------------------------------
  elif [[ -f /etc/arch-version ]]; then 
    __osname="arch"
    __osversion="rolling"
  elif [[ -f /etc/slackware-version ]]; then 
    __osname=$(tr '[:upper:]' '[:lower:]' < /etc/slackware-version | sed s/\ [0-9.-\(\)]*//g)
    __osversion=
  elif [[ -f /etc/debian_version ]]; then 
    __osname="debian"
    read __osversion < /etc/debian_version
  fi
  # Check /etc/os-release
  # If not, check lsb-release 
  # If not, check distro-specific files
  # If not, check package-managers

fi

export __ostype
export __osfamily
export __osname
export __osversion
export __kernelversion
export __arch 
