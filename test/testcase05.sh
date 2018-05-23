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
  __testcase05_srcd=1
  if [[ "${__testcase05_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase05_srcd=0
    __testcase05_external_usage=1
    __testcase05_tmp_surce_idx=1
  fi 
else
  __testcase05_srcd=0
  [[ "${__testcase05_usage+x}" ]] && unset -v __testcase05_usage
  [[ "${__testcase05_helptext+x}" ]] && unset -v __testcase05_helptext
fi
__testcase05_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase05_tmp_source_idx:-0}]}")" && pwd)"
__testcase05_file="${__testcase05_dir}/$(basename "${BASH_SOURCE[${__testcase05_tmp_source_idx:-0}]}")"
__testcase05_base="$(basename "${__testcase05_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
function __testcase05_source_lib () {
local module="${1:-}"
local folders=( "${__testcase05_dir}" "${__testcase05_dir}/lib"  "/usr/local/lib" "${HOME}/.local/lib")
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
    echo "Fatal error: ${module} not exists or readable!"
    exit 1
  fi
}
__testcase05_source_lib log.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 05: testing localization"
echo "Test how to behaviour b3bp in a localized environment with direct call"
echo "Acceptance: messages in the specified languages"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

en=$( LANGUAGE=en ../b3bp -f test )
hu=$( LANGUAGE=hu ../b3bp -f test )

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

echo "${en}"
if [[ "${en}" != *"Demo and test of the Bash-script template"* ]]; then
  result=1
fi

echo "${hu}"
if [[ "${hu}" != *"Demó és a Bash-szkript sablon tesztelése"* ]]; then
  result=1
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
