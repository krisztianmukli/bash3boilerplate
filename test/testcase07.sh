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
  __testcase07_srcd=1
  if [[ "${__testcase07_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase07_srcd=0
    __testcase07_external_usage=1
    __testcase07_tmp_surce_idx=1
  fi 
else
  __testcase07_srcd=0
  [[ "${__testcase07_usage+x}" ]] && unset -v __testcase07_usage
  [[ "${__testcase07_helptext+x}" ]] && unset -v __testcase07_helptext
fi
__testcase07_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase07_tmp_source_idx:-0}]}")" && pwd)"
__testcase07_file="${__testcase07_dir}/$(basename "${BASH_SOURCE[${__testcase07_tmp_source_idx:-0}]}")"
__testcase07_base="$(basename "${__testcase07_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
function __testcase07_source_lib () {
local module="${1:-}"
local folders=( "${__testcase07_dir}" "${__testcase07_dir}/lib"  "/usr/local/lib" "${HOME}/.local/lib")
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
__testcase07_source_lib log.sh
__testcase07_source_lib ask.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 07: Testing simple question"
echo "Testing simple question library"
echo "Acceptance: Three Yes answer"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0
declare -i yesanswer=0

# Steps of testcase
if ask "This is a simple question?"; then yesanswer+=1; fi
if ask "This is a simple question, with default Yes?" Y; then yesanswer+=1; fi
if ask "This is a simple question, with default No?" N; then yesanswer+=1; fi

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"
if [[ "${yesanswer}" != 3 ]]; then result=1; fi
#-------------------------------------------------------------------------------
# Print results
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
