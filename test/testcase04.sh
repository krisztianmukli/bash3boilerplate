#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
function __b3bp_log () {
  local log_level="${1}"
  shift

  # shellcheck disable=SC2034
  local color_debug="\x1b[35m"
  # shellcheck disable=SC2034
  local color_info="\x1b[32m"
  # shellcheck disable=SC2034
  local color_notice="\x1b[34m"
  # shellcheck disable=SC2034
  local color_warning="\x1b[33m"
  # shellcheck disable=SC2034
  local color_error="\x1b[31m"
  # shellcheck disable=SC2034
  local color_critical="\x1b[1;31m"
  # shellcheck disable=SC2034
  local color_alert="\x1b[1;33;41m"
  # shellcheck disable=SC2034
  local color_emergency="\x1b[1;4;5;33;41m"

  local colorvar="color_${log_level}"

  local color="${!colorvar:-${color_error}}"
  local color_reset="\x1b[0m"

  if [[ "${NO_COLOR:-}" = "true" ]] || ( [[ "${TERM:-}" != "xterm"* ]] && [[ "${TERM:-}" != "screen"* ]] ) || [[ ! -t 2 ]]; then
    if [[ "${NO_COLOR:-}" != "false" ]]; then
      # Don't use colors on pipes or non-recognized terminals
      color=""; color_reset=""
    fi
  fi

  # all remaining arguments are to be printed
  local log_line=""

  while IFS=$'\n' read -r log_line; do
    echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" "${log_level}")${color_reset} ${log_line}" 1>&2
  done <<< "${@:-}"
}

function emergency () {                                __b3bp_log emergency "${@}"; exit 1; }
function alert ()     { [[ "${LOG_LEVEL:-0}" -ge 1 ]] && __b3bp_log alert "${@}"; true; }
function critical ()  { [[ "${LOG_LEVEL:-0}" -ge 2 ]] && __b3bp_log critical "${@}"; true; }
function error ()     { [[ "${LOG_LEVEL:-0}" -ge 3 ]] && __b3bp_log error "${@}"; true; }
function warning ()   { [[ "${LOG_LEVEL:-0}" -ge 4 ]] && __b3bp_log warning "${@}"; true; }
function notice ()    { [[ "${LOG_LEVEL:-0}" -ge 5 ]] && __b3bp_log notice "${@}"; true; }
function info ()      { [[ "${LOG_LEVEL:-0}" -ge 6 ]] && __b3bp_log info "${@}"; true; }
function debug ()     { [[ "${LOG_LEVEL:-0}" -ge 7 ]] && __b3bp_log debug "${@}"; true; }

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case 04: Set usage string exteernally"
echo "Testing how to set __b3bp_usage string externally and call the script"
echo "Acceptance: call the script and using the externally specified usage string"
# Start testcase
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase
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
# Change localization for proper testing
source ../b3bp -f test

# Start validation
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

debug "${__b3bp_usage}"
# When source a script, LANGUAGE environmental variable 
if [[ "${__b3bp_usage}" != "${test_usage}" ]]; then
  result=1
  error "Usage string externally not writable!"
fi

# Print results
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
