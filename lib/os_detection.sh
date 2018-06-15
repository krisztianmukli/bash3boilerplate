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

  if [[ "${__osfamily}" = "suse-based" ]]; then [[ "${force}" = "0" ]] && echo "zypper install" || echo "zypper install --non-interactive"; # SUSE / openSUSE
  elif [[ "${__osfamily}" = "debian-based" ]]; then [[ "${force}" = "0" ]] && echo "apt-get install" || echo "apt-get install --yes"; # Debian / Ubuntu Based Systems
  elif [[ "${__osfamily}" = "fedora-based" ]]; then [[ "${force}" = "0" ]] && echo "dnf install" || echo "dnf install --assumeyes"; # Modern Fedora and derivatives
  elif [[ "${__osfamily}" = "redhat-based" ]]; then [[ "${force}" = "0" ]] && echo "yum install" || echo "yum install -y"; # Red Hat / Fedora or derivatives
  elif [[ "${__osfamily}" = "arch-based" ]]; then [[ "${force}" = "0" ]] && echo "pacman -S" || echo "pacman -S --noconfirm"; # Arch Linux or derivates
  elif [[ "${__osfamily}" = "slackware-based" ]]; then
    if [[ -x /usr/sbin/slackpkg ]]; then echo "slackpkg install" # Slackware
    elif [[ -x /usr/sbin/slapt-get ]]; then echo "slapt-get --install"; # Vector Linux / Slackware
    elif [[ -x /usr/sbin/netpkg ]]; then  echo "netpkg" ; # Zenwalk / Slackware
    fi

  elif [[ "${__osfamily}" = "mandriva-based" ]]; then [[ "${force}" = "0" ]] && echo "urpmi" || echo "urpmi --force"; # OpenMandriva Linux
  elif [[ "${__osfamily}" = "gentoo-based" ]]; then echo "emerge"; # Gentoo
  elif [[ "${__osfamily}" = "clearlinux" ]]; then echo "swupd bundle-add" ; # Clear Linux
  elif [[ "${__osfamily}" = "sabayon" ]]; then [[ "${force}" = "0" ]] && echo "equo install --ask" || echo "equo install"; # Sabayon
  elif [[ "${__osfamily}" = "voidlinux" ]]; then echo "xbps-install -S" ; # Void Linux
  elif [[ "${__osfamily}" = "alpinelinux" ]]; then echo "apk add"; # Alpine Linux
  elif [[ "${__osfamily}" = "soluslinux" ]]; then [[ "${force}" = "0" ]] && echo "eopkg install" || echo "eopkg install --yes-all"; # Solus Linux
  elif [[ "${__osfamily}" = "openwrt" ]]; then echo "opkg install"; # OpenWRT
  elif [[ "${__osfamily}" = "android-termux" ]]; then echo "pkg install"; # Android (termux)
  elif [[ "${__osfamily}" = "solaris-based" ]]; then 
    if [[ "${__osname=}" = "solaris" ]]; then echo "pkg install" # Solaris
    elif [[ "${__osname=}" = "openindiana" ]]; then echo "pkg install" # OpenIndiana 
    elif [[ "${__osname=}" = "smartos" ]]; then echo "pkgin in" # SmartOS
    elif [[ "${__osname=}" = "omnios" ]]; then echo "pkg install" # OmniOS
    elif [[ "${__osname=}" = "nexentastor" ]]; then echo "apt-get install" # NexentaStor
    fi

  elif [[ "${__osfamily}" = "darwin" ]]; then # Mac OSX, requires Homebrew or Macports
    if which brew ; then echo "brew install"; # Homebrew: https://brew.sh/
    elif which port ; then echo "port install" # MacPorts: https://www.macports.org/
    else echo "echo \"For installing following packages in macOS, you must use Homebrew or Macports:\""
    fi

  elif [[ "${__osfamily}" = "bsd" ]]; then
    if [[ "${__osname=}" = "freebsd" ]]; then echo "pkg install"; # FreeBSD
    elif [[ "${__osname=}" = "openbsd" ]]; then echo "pkg_add"; # OpenBSD
    elif [[ "${__osname=}" = "netbsd" ]]; then echo "pkg_add"; # NetBSD
    elif [[ "${__osname}" = "dragonflybsd" ]]; then echo "pkg install"; # DragonFlyBSD
    elif [[ "${__osname=}" = "openbsd" ]]; then echo "mport install"; # MidnightBSD
    fi

  elif [[ "${__osfamily}" = "cygwin" ]]; then # Cygwin, requires apt-cyg - https://github.com/transcode-open/apt-cyg
    if which apt-cyg > /dev/null 2>/dev/null ; then
      echo "apt-cyg install";
    else
      echo "echo \"Installing following packages from shell in cygwin, must be use apt-cyg, or install them with Cygwin setup.exe: \""
    fi
  elif [[ "${__osfamily}" = "msys" ]]; then echo "mingw-get install"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  elif [[ "${__osfamily}" = "msys2" ]]; then [[ "${force}" = "0" ]] && echo "pacman -S" || echo "pacman -S --noconfirm";  # MSYS2 software distro and building platform for Windows
  elif [[ "${__osfamily}" = "haiku" ]]; then echo "installoptionalpackage -a" # Haiku
  elif [[ "${__osfamily}" = "minix" ]]; then echo "pkgin install" # Minix
  else echo "echo \"Unknown or unsupported operating system, cannot install following packages:\" "; # Unknown or unsupported operating system
  fi
}
function install_pkgs(){
local pkgs="${1:-}"
local force="${2:-}"
local installcmd=$( install_cmd "${force}" )
  
  if [[ ! -z "${pkgs}" ]] && [[ ! -z "${installcmd}" ]]; then
    if [[ $EUID != 0 ]]; then
      if which sudo; then # Check sudo is exits
        eval "sudo ${installcmd} ${pkgs}"
      else
        echo "You need higher privileges for this operation!"
      fi
    else
      eval "${installcmd} ${pkgs}"
    fi
  fi

  return $?
  
}
function remove_cmd(){
local force="${1:-}"

  if [[ "${__osfamily}" = "suse-based" ]]; then [[ "${force}" = "0" ]] && echo "zypper remove" || echo "zypper remove --non-interactive"; # SUSE / openSUSE
  elif [[ "${__osfamily}" = "debian-based" ]]; then [[ "${force}" = "0" ]] && echo "apt-get remove" || echo "apt-get remove --yes"; # Debian / Ubuntu Based Systems
  elif [[ "${__osfamily}" = "fedora-based" ]]; then [[ "${force}" = "0" ]] && echo "dnf remove" || echo "dnf remove --assumeyes"; # Modern Fedora and derivatives
  elif [[ "${__osfamily}" = "redhat-based" ]]; then [[ "${force}" = "0" ]] && echo "yum remove" || echo "yum remove -y"; # Red Hat / Fedora or derivatives
  elif [[ "${__osfamily}" = "arch-based" ]]; then [[ "${force}" = "0" ]] && echo "pacman -R" || echo "pacman -R --noconfirm"; # Arch Linux or derivates
  elif [[ "${__osfamily}" = "slackware-based" ]]; then
    if [[ -x /usr/sbin/slackpkg ]]; then echo "slackpkg remove" # Slackware
    elif [[ -x /usr/sbin/slapt-get ]]; then echo "slapt-get --remove"; # Vector Linux / Slackware
    elif [[ -x /usr/sbin/netpkg ]]; then  echo "netpkg remove" ; # Zenwalk / Slackware
    fi

  elif [[ "${__osfamily}" = "mandriva-based" ]]; then echo "urpme"; # OpenMandriva Linux
  elif [[ "${__osfamily}" = "gentoo-based" ]]; then echo "emerge -aC"; # Gentoo
  elif [[ "${__osfamily}" = "clearlinux" ]]; then echo "swupd bundle-remove" ; # Clear Linux
  elif [[ "${__osfamily}" = "sabayon" ]]; then [[ "${force}" = "0" ]] && echo "equo remove --ask" || echo "equo remove"; # Sabayon
  elif [[ "${__osfamily}" = "voidlinux" ]]; then echo "xbps-remove" ; # Void Linux
  elif [[ "${__osfamily}" = "alpinelinux" ]]; then echo "apk del"; # Alpine Linux
  elif [[ "${__osfamily}" = "soluslinux" ]]; then [[ "${force}" = "0" ]] && echo "eopkg remove" || echo "eopkg remove --yes-all"; # Solus Linux
  elif [[ "${__osfamily}" = "openwrt" ]]; then echo "opkg remove"; # OpenWRT
  elif [[ "${__osfamily}" = "android-termux" ]]; then echo "pkg uninstall"; # Android (termux)
  elif [[ "${__osfamily}" = "solaris-based" ]]; then 
    if [[ "${__osname=}" = "solaris" ]]; then echo "pkg uninstall" # Solaris
    elif [[ "${__osname=}" = "openindiana" ]]; then echo "pkg uninstall" # OpenIndiana 
    elif [[ "${__osname=}" = "smartos" ]]; then echo "pkgin rm" # SmartOS
    elif [[ "${__osname=}" = "omnios" ]]; then echo "pkg uninstall" # OmniOS
    elif [[ "${__osname=}" = "nexentastor" ]]; then echo "apt-get remove" # NexentaStor
    fi

  elif [[ "${__osfamily}" = "darwin" ]]; then # Mac OSX
    if which brew ; then echo "brew remove"; # Homebrew: https://brew.sh/
    elif which port ; then echo "port uninstall" # MacPorts: https://www.macports.org/
    else echo "echo \"For removing following packages in macOS, you must use Homebrew or Macports:\""
    fi

  elif [[ "${__osfamily}" = "bsd" ]]; then
    if [[ "${__osname=}" = "freebsd" ]]; then echo "pkg remove"; # FreeBSD
    elif [[ "${__osname=}" = "openbsd" ]]; then echo "pkg_delete"; # OpenBSD
    elif [[ "${__osname=}" = "netbsd" ]]; then echo "pkg_delete"; # NetBSD
    elif [[ "${__osname}" = "dragonflybsd" ]]; then echo "pkg delete"; # DragonFlyBSD
    elif [[ "${__osname=}" = "openbsd" ]]; then echo "mport delete"; # MidnightBSD
    fi

  elif [[ "${__osfamily}" = "cygwin" ]]; then echo "apt-cyg remove"; # Cygwin, requires apt-cyg - https://github.com/transcode-open/apt-cyg
    if which apt-cyg > /dev/null 2>/dev/null ; then
      echo "apt-cyg remove";
    else
      echo "echo \"Removing following packages from shell in cygwin, must be use apt-cyg, or install them with Cygwin setup.exe: \""
    fi
  elif [[ "${__osfamily}" = "msys" ]]; then echo "mingw-get remove"; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  elif [[ "${__osfamily}" = "msys2" ]]; then [[ "${force}" = "0" ]] && echo "pacman -R" || echo "pacman -R --noconfirm";  # MSYS2 software distro and building platform for Windows
  elif [[ "${__osfamily}" = "haiku" ]]; then echo "echo \"Proper package management not implemeted in Haiku, yet!\"" # Haiku
  elif [[ "${__osfamily}" = "minix" ]]; then echo "pkgin remove" # Minix
  else echo "echo \"Unknown or unsupported operating system, cannot remove following packages:\""; # Unknown or unsupported operating system
  fi
}
function remove_pkgs(){
local pkgs="${1:-}"
local force="${2:-}"
local removecmd=$( remove_cmd "${force}" )
  
  if [[ ! -z "${pkgs}" ]] && [[ ! -z "${removecmd}" ]]; then
    if [[ $EUID != 0 ]]; then
      if which sudo; then # Check sudo is exits
        eval "sudo ${removecmd} ${pkgs}"
      else
        echo "You need higher privileges for this operation!"
      fi
    else
      eval "${removecmd} ${pkgs}"
    fi
  fi

  return $?
  
}
function check_pkgs(){
local pkgs="${1:-}"
local missingpkgs=""

 if [[ ! -z "${pkgs}" ]]; then
   if [[ "${__osfamily}" = "suse-based" ]]; then # SUSE / openSUSE
     for pkg in "${pkgs[@]}"; do
       if ! zypper -is | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
     done
    elif [[ "${__osfamily}" = "debian-based" ]]; then # Debian / Ubuntu Based Systems
     for pkg in "${pkgs[@]}"; do 
       if ! dpkg -l "${pkg}" | grep ii >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
     done     
    elif [[ "${__osfamily}" = "fedora-based" ]]; then # Modern Fedora and derivatives
     for pkg in "${pkgs[@]}"; do 
       if ! dnf list installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
     done     
    elif [[ "${__osfamily}" = "redhat-based" ]]; then # Red Hat / Fedora or derivatives
     for pkg in "${pkgs[@]}"; do 
       if ! yum list installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
     done         
    elif [[ "${__osfamily}" = "arch-based" ]]; then # Arch Linux or derivates
     for pkg in "${pkgs[@]}"; do 
       if ! pacman -Qi "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
     done     
    elif [[ "${__osfamily}" = "slackware-based" ]]; then
      if [[ -x /usr/sbin/slackpkg ]]; then # Slackware
       for pkg in "${pkgs[@]}"; do 
         if ! slackpkg search "${pkg}" | grep "installed" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
       done      
      elif [[ -x /usr/sbin/slapt-get ]]; then # Vector Linux / Slackware
       for pkg in "${pkgs[@]}"; do 
         if ! slapt-get --installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
       done       
      elif [[ -x /usr/sbin/netpkg ]]; then # Zenwalk / Slackware
       for pkg in "${pkgs[@]}"; do 
         if ! netpk list I | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
       done       
      fi
    elif [[ "${__osfamily}" = "mandriva-based" ]]; then # OpenMandriva Linux
      for pkg in "${pkgs[@]}"; do 
        if ! rpm -qa | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done 
    elif [[ "${__osfamily}" = "gentoo-based" ]]; then # Gentoo
      for pkg in "${pkgs[@]}"; do 
        if ! qlist -I | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done
    elif [[ "${__osfamily}" = "clearlinux" ]]; then # Clear Linux
      for pkg in "${pkgs[@]}"; do 
        if ! swupd bundle-list | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done    
    elif [[ "${__osfamily}" = "sabayon" ]]; then # Sabayon
      for pkg in "${pkgs[@]}"; do 
        if ! equo q list installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done      
    elif [[ "${__osfamily}" = "voidlinux" ]]; then # Void Linux
      for pkg in "${pkgs[@]}"; do 
        if ! xbps-query -l | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done    
    elif [[ "${__osfamily}" = "alpinelinux" ]]; then # Alpine Linux
      for pkg in "${pkgs[@]}"; do 
        if ! apk info | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done     
    elif [[ "${__osfamily}" = "soluslinux" ]]; then echo # Solus Linux
      for pkg in "${pkgs[@]}"; do 
        if ! eopkg list-installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done       
    elif [[ "${__osfamily}" = "openwrt" ]]; then # OpenWRT
      for pkg in "${pkgs[@]}"; do 
        if ! opkg list-installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done      
    elif [[ "${__osfamily}" = "android-termux" ]]; then # Android (termux)
      for pkg in "${pkgs[@]}"; do 
       if ! dpkg -l "${pkg}" | grep ii >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done
      
    elif [[ "${__osfamily}" = "solaris-based" ]]; then 
      if [[ "${__osname=}" = "solaris" ]]; then # Solaris
        for pkg in "${pkgs[@]}"; do 
         if ! pkg list "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done       
      elif [[ "${__osname=}" = "openindiana" ]]; then # OpenIndiana 
        for pkg in "${pkgs[@]}"; do 
         if ! pkg list "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done        
      elif [[ "${__osname=}" = "smartos" ]]; then echo "pkgin in" # SmartOS
        for pkg in "${pkgs[@]}"; do 
          if ! pkgin ls | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done
      elif [[ "${__osname=}" = "omnios" ]]; then # OmniOS
        for pkg in "${pkgs[@]}"; do 
         if ! pkg list "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done      
      elif [[ "${__osname=}" = "nexentastor" ]]; then # NexentaStor
        for pkg in "${pkgs[@]}"; do 
         if ! dpkg -l "${pkg}" | grep ii >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done      
      fi
      
    elif [[ "${__osfamily}" = "darwin" ]]; then # Mac OSX, requires Homebrew or Macports
      if which brew; then # Homebrew: https://brew.sh/
        for pkg in "${pkgs[@]}"; do 
          if ! brew list | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done
      elif which port; then # MacPorts: https://www.macports.org/
        for pkg in "${pkgs[@]}"; do 
          if ! port installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done      
      fi

    elif [[ "${__osfamily}" = "bsd" ]]; then
      if [[ "${__osname=}" = "freebsd" ]]; then # FreeBSD
        for pkg in "${pkgs[@]}"; do 
         if ! pkg info --all | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done      
      elif [[ "${__osname=}" = "openbsd" ]]; then # OpenBSD
        for pkg in "${pkgs[@]}"; do 
         if ! pkg_info -a | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done        
      elif [[ "${__osname=}" = "netbsd" ]]; then # NetBSD
        for pkg in "${pkgs[@]}"; do 
         if ! pkg_info -a | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done        
      elif [[ "${__osname}" = "dragonflybsd" ]]; then # DragonFlyBSD
        for pkg in "${pkgs[@]}"; do 
         if ! pkg info | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done      
      elif [[ "${__osname=}" = "openbsd" ]]; then # MidnightBSD
        for pkg in "${pkgs[@]}"; do 
         if ! mport list | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
        done
      fi

    elif [[ "${__osfamily}" = "cygwin" ]] && which apt-cyg > /dev/null 2>/dev/null; then # Cygwin, requires apt-cyg - https://github.com/transcode-open/apt-cyg
      for pkg in "${pkgs[@]}"; do 
        if ! cygcheck -l | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done    
    elif [[ "${__osfamily}" = "msys" ]]; then # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
      for pkg in "${pkgs[@]}"; do 
        if ! mingw-get-info installed | grep "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done     
    elif [[ "${__osfamily}" = "msys2" ]]; then # MSYS2 software distro and building platform for Windows
      for pkg in "${pkgs[@]}"; do 
        if ! pacman -Qi "${pkg}" >/dev/null 2>/dev/null; then missingpkgs+=" ${pkg}"; fi
      done    
    elif [[ "${__osfamily}" = "haiku" ]]; then missingpkgs="${pkgs}" # Haiku, there is no usable method
    elif [[ "${__osfamily}" = "minix" ]]; then missingpkgs="${pkgs}" # Minix, there is no usable method
    fi
 fi
 
 echo "${missingpkgs}"
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
  elif [[ -x /usr/sbin/slackpkg ]]; then __osfamily="slackware-based"; # Slackware
  elif [[ -x /usr/sbin/slapt-get ]]; then __osfamily="slackware-based"; # Vector Linux / Slackware
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
      __osname="nexentastor"
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
elif [[ "${__ostype}" = "midnightbsd" ]]; then # MidnightBSD
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
elif [[ "${__ostype}" = "minix" ]]; then # Haiku
  __osfamily="minix"; 
  __osname="minix"
  __osversion=$(uname -r)
fi

export __ostype
export __osfamily
export __osname
export __osversion
export __kernelversion
export __arch
export __subsystem
