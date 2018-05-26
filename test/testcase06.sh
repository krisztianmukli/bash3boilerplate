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
  __testcase06_srcd=1
  if [[ "${__testcase06_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase06_srcd=0
    __testcase06_external_usage=1
    __testcase06_tmp_surce_idx=1
  fi 
else
  __testcase06_srcd=0
  [[ "${__testcase06_usage+x}" ]] && unset -v __testcase06_usage
  [[ "${__testcase06_helptext+x}" ]] && unset -v __testcase06_helptext
fi
__testcase06_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase06_tmp_source_idx:-0}]}")" && pwd)"
__testcase06_file="${__testcase06_dir}/$(basename "${BASH_SOURCE[${__testcase06_tmp_source_idx:-0}]}")"
__testcase06_base="$(basename "${__testcase06_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
function __testcase06_source_lib () {
local module="${1:-}"
local folders=( "${__testcase06_dir}" "${__testcase06_dir}/lib"  "/usr/local/lib" "${HOME}/.local/lib")
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
__testcase06_source_lib log.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 06: testing localization - sourced use"
echo "Test how to behaviour b3bp in a localized environment with sourced use"
echo "Acceptance: messages in the specified languages"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

hu_output=$(LANGUAGE=hu source ../b3bp -f test && main)

[[ "${__b3bp_usage+x}" ]] && unset -v __b3bp_usage
en_output=$(LANGUAGE=en source ../b3bp -f test && main)

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

echo "${hu_output:-}"
echo "${en_output:-}"
if [[ "${hu_output}" != *"Demó és a Bash-szkript sablon tesztelése"* ]]; then
  result=1
fi

if [[ "${en_output}" != *"Demo and test of the Bash-script template"* ]]; then
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
