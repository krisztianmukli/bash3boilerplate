#!/usr/bin/env bash
function install_script() { # __b3bp_dir __b3bp_base
local sourcedir="${1:-}"
local scriptfile="${2:-}"
local unsupported_header=$"Unsupported operating system."
local unsupported_message=$"Install script manually: 
 * Copy the script and the lib folder to your PATH.
 * Copy to locale folder to your locale folder."

  source ini_val.sh
  source display_info.sh
  [[ "${DISTROTYPE+x}" ]] || source os_detection.sh

  libs=$( ini_val "${sourcedir}/b3bp_install.ini" install.libs )
  if [[ "${sourcedir:-}/${scriptfile:-}" ]]; then
    # Check OS version
    if [[ "${OSTYPE}" = "linux-gnu" && "${DISTROTYPE:-}" = "debian-based" ]]; then
      if [[ $EUID != 0 ]]; then
        targetdir="${HOME}/.local/bin"
        localedir="${HOME}/.local/share/locale"        

	      # Check and create destination
        [[ ! -d "${targetdir}" ]] && mkdir "${targetdir}"
        [[ ! -d "${targetdir}/lib" && -d "${sourcedir}/lib" ]] && mkdir "${targetdir}/lib"
        [[ ! -d "${localedir}" && -d "${sourcedir}/locale" ]] && mkdir "${localedir}"

        # Copy script to ~/.local/bin
        cp -i "${sourcedir}/${scriptfile}" "${targetdir}"
	      for lib in $libs; do
	        cp -i "${sourcedir}/lib/${lib}" "${targetdir}/lib"
	      done 	
        #cp -ir "${sourcedir}/lib/." "${targetdir}/lib"
        cp -ir "${sourcedir}/locale/." "${localedir}"

        # Ubuntu-based systems already contains user private bin in ~/.profile, but Debian not
        if ! grep -q "\$HOME/.local/bin" "${HOME}/.profile"; then
          {
            echo "" 
            echo "# set PATH so it includes user's private bin if it exists"
            echo "if [ -d \"\$HOME/.local/bin\" ] ; then"
            echo "    PATH=\"\$HOME/.local/bin:\$PATH\" "
            echo "fi" 
          } >> "${HOME}/.profile"
          warning "Run 'source ~/.profile' command to reload PATH variable!"
        fi
        
        source "${HOME}/.profile" && export PATH
        info "Installation was succesful to ${targetdir}"
      else
        targetdir="/usr/local/bin"
        localedir="/usr/share/locale"

        # Copy script to ~/.local/bin
        cp -i "${sourcedir}/${scriptfile}" "${targetdir}"
        for lib in $libs; do
          cp -i "${sourcedir}/lib/${lib}" "${targetdir}/lib"
        done 	
        #cp -ir "${sourcedir}/lib/." "${targetdir}/lib"
        cp -ir "${sourcedir}/locale/." "${localedir}"

        info "Installation was succesful to ${targetdir}"
      fi

    else
      display_info "${unsupported_header}" "${unsupported_message}"
    fi

  fi
  
  exit 1
}
