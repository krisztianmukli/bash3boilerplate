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
  __testcase04_srcd=1
  if [[ "${__testcase04_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase04_srcd=0
    __testcase04_external_usage=1
    __testcase04_tmp_surce_idx=1
  fi 
else
  __testcase04_srcd=0
  [[ "${__testcase04_usage+x}" ]] && unset -v __testcase04_usage
  [[ "${__testcase04_helptext+x}" ]] && unset -v __testcase04_helptext
fi
__testcase04_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase04_tmp_source_idx:-0}]}")" && pwd)"
__testcase04_file="${__testcase04_dir}/$(basename "${BASH_SOURCE[${__testcase04_tmp_source_idx:-0}]}")"
__testcase04_base="$(basename "${__testcase04_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
function __testcase04_source_lib () {
local module="${1:-}"
local folders=( "${__testcase04_dir}" "${__testcase04_dir}/lib"  "/usr/local/lib" "${HOME}/.local/lib")
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
__testcase04_source_lib log.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 04: Set usage string externally"
echo "Testing how to set __b3bp_usage string externally and call the script"
echo "Acceptance: call the script and using the externally specified usage string"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

read -r -d '' test_usage <<-'EOF' || true
b3bp [ARGUMENTS] [PARAMETERS]
Available arguments:
  -a  Alpha
  -b  Bravo
  -c  Charlie
  -d  Delta
  -e  Echo
  -f  Foxtrott
  -g  Golf
  -h  Hotel
  -i  India
  -j  Juliett
  -k  Kilo
  -l  Lima
  -m  Mike
  -n  November
  -o  Oscar
  -p  Papa
  -q  Quebec
  -r  Romeo
  -s  Sierra
  -t  Tango
  -u  Uniform
  -v  Victor
  -w  Wiskey
  -x  X-Ray
  -y  Yankee
  -z  Zulu
  -0  Zero
  -1  One
  -2  Two
  -3  Three
  -4  Four
  -5  Five
  -6  Six
  -7  Seven
  -8  Eight
  -9  Nine
EOF

__b3bp_usage="${test_usage}"
source b3bp -f test

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

debug "${__b3bp_usage}"
# When source a script, LANGUAGE environmental variable 
if [[ "${__b3bp_usage}" != "${test_usage}" ]]; then
  result=1
  error "Usage string externally not writable!"
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
