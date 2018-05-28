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
  __testcasexx_srcd=1
  if [[ "${__testcasexx_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcasexx_srcd=0
    __testcasexx_external_usage=1
    __testcasexx_tmp_surce_idx=1
  fi 
else
  __testcasexx_srcd=0
  [[ "${__testcasexx_usage+x}" ]] && unset -v __testcasexx_usage
  [[ "${__testcasexx_helptext+x}" ]] && unset -v __testcasexx_helptext
fi
__testcasexx_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcasexx_tmp_source_idx:-0}]}")" && pwd)"
__testcasexx_file="${__testcasexx_dir}/$(basename "${BASH_SOURCE[${__testcasexx_tmp_source_idx:-0}]}")"
__testcasexx_base="$(basename "${__testcasexx_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
export PATH="${__testcasexx_dir}/lib:${HOME}/.local/share/${__testcasexx_base}:$PATH"
source log.sh
source os_detection.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case XX: What testing in this testcase"
echo "Description of test case"
echo "Acceptance: acceptance conditions"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

#-------------------------------------------------------------------------------
# Print results
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
