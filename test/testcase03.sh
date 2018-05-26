#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

#===============================================================================
# Globals section
#===============================================================================

#-------------------------------------------------------------------------------
# Environment variables
#-------------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] ; then
  __testcase03_srcd=1
  if [[ "${__testcase03_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase03_srcd=0
    __testcase03_external_usage=1
    __testcase03_tmp_surce_idx=1
  fi 
else
  __testcase03_srcd=0
  [[ "${__testcase03_usage+x}" ]] && unset -v __testcase03_usage
  [[ "${__testcase03_helptext+x}" ]] && unset -v __testcase03_helptext
fi
__testcase03_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase03_tmp_source_idx:-0}]}")" && pwd)"
__testcase03_file="${__testcase03_dir}/$(basename "${BASH_SOURCE[${__testcase03_tmp_source_idx:-0}]}")"
__testcase03_base="$(basename "${__testcase03_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
function __testcase03_source_lib () {
local module="${1:-}"
local folders=( "${__testcase03_dir}" "${__testcase03_dir}/lib"  "/usr/local/lib" "${HOME}/.local/lib")
local success=false

  if [[ "${module}" = *"/"* && -e "${module}" && -r "${module}" ]]; then
      source "${module}" && success=true
  else
    for folder in "${folders[@]}"; do
      if [[ -e "${folder}/${module}" && -r "${folder}/${module}" ]]; then
        source  "${folder}/${module}" && success=true && break
      fi
    done
  fi

  if [[ "${success}" = false ]]; then
    if [[ -n "$(type -t error)" && "$(type -t error)" = function ]]; then 
      error "Fatal error: ${module} not exists or readable!"
     else
       echo "Fatal error: ${module} not exists or readable!"
     fi
    exit 1
  fi
}
__testcase03_source_lib log.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 03: Test direct call"
echo "Test behaviour when calling directly from script or cmd."
echo "Acceptance: calling b3bp and echoing main functions "

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

var=$( ./b3bp -f test )

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

debug "${var}"
if [[ "${var}" != *"BASH3 Boilerplate"* ]]; then
  result=1
  error "Return value of called script is not readable!"
fi

#-------------------------------------------------------------------------------
# Print results
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
