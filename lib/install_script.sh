#!/usr/bin/env bash

function copy_files() {
local sourcedir="${1:-}"
local targetdir="${2:-}"

  libs=$( ini_val "${sourcedir}/b3bp_install.ini" install.libs )
  # Check and create destination
  [[ ! -d "${targetdir}" ]] && mkdir "${targetdir}"
  [[ ! -d "${targetdir}/lib" && -d "${sourcedir}/lib" ]] && mkdir "${targetdir}/lib"
  [[ ! -d "${localedir}" && -d "${sourcedir}/locale" ]] && mkdir "${localedir}"

  # Copy files from sourcedir to targetdir
  cp -i "${sourcedir}/${scriptfile}" "${targetdir}"
        for lib in $libs; do
          cp -i "${sourcedir}/lib/${lib}" "${targetdir}/lib"
        done 	
  cp -ir "${sourcedir}/locale/." "${localedir}"

}

function install_script() {
local sourcedir="${1:-}"
local scriptfile="${2:-}"

  source ini_val.sh
  source display_info.sh
  [[ "${DISTROTYPE+x}" ]] || source os_detection.sh

  if [[ "${sourcedir:-}/${scriptfile:-}" ]]; then
    # Check OS version
    if [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "debian-based" ]]; then
      if [[ $EUID != 0 ]]; then
        targetdir="${HOME}/.local/bin"
        localedir="${HOME}/.local/share/locale"        
	
        copy_files "${sourcedir}" "${targetdir}"

        # Ubuntu-based systems already contains user private bin in ~/.profile, but Debian not
        if ! grep -q "\$HOME/.local/bin" "${HOME}/.profile"; then
          {
            echo "" 
            echo "# set PATH so it includes user's private bin if it exists"
            echo "if [ -d \"\$HOME/.local/bin\" ] ; then"
            echo "    PATH=\"\$HOME/.local/bin:\$PATH\" "
            echo "fi" 
          } >> "${HOME}/.profile"
          warning "~/.profile was updated, please login again or run 'source ~/.profile' command to reload PATH variable!"
        fi
        
        source "${HOME}/.profile" && export PATH
        info "Installation was succesful to ${targetdir}"
      else
        targetdir="/usr/local/bin"
        localedir="/usr/local/share/locale"

        copy_files "${sourcedir}" "${targetdir}"
        info "Installation was succesful to ${targetdir}"
      fi

    else
      local unsupported_header=$"Unsupported operating system."
      local unsupported_message=$"Install script manually: 
 * Copy the script and the lib folder to your PATH.
 * Copy to locale folder to your locale folder."
      
      display_info $"Unsupported operating system." $"Install script manually: 
 * Copy the script and the lib folder to your PATH.
 * Copy to locale folder to your locale folder."
    fi

  fi
  
  exit 1
}
