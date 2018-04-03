#!/usr/bin/env bash
# This file:
#
#  - First version of testing BASH4 Boilerplate
#
# Usage:
#
#  ./test
#
# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  __i_am_main_script="0" # false

  if [[ "${__usage+x}" ]]; then
    if [[ "${BASH_SOURCE[1]}" = "${0}" ]]; then
      __i_am_main_script="1" # true
    fi

    __b3bp_external_usage="true"
    __b3bp_tmp_source_idx=1
  fi
else
  __i_am_main_script="1" # true
  [[ "${__usage+x}" ]] && unset -v __usage
  [[ "${__helptext+x}" ]] && unset -v __helptext
fi

# Set magic variables for current file, directory, os, etc.
__dir="$(cd "$(dirname "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")"
__base="$(basename "${__file}" .sh)"


# Define the environment variables (and their defaults) that this script depends on
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected


#-------------------------------------------------------------------------------
# Localization
#-------------------------------------------------------------------------------
__test_locale="${__dir}/locale"
__test_syslocale="/usr/share/locale"
TEXTDOMAIN="${__base}"
TEXTDOMAINDIR="$([[ -d "${__test_locale}" ]] && echo "${__test_locale}" || echo "${__test_syslocale}")"
### Functions
##############################################################################
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

function help () {
  echo "" 1>&2
  echo " ${*}" 1>&2
  echo "" 1>&2
  echo "  ${__usage:-No usage available}" 1>&2
  echo "" 1>&2

  if [[ "${__helptext:-}" ]]; then
    echo " ${__helptext}" 1>&2
    echo "" 1>&2
  fi

  exit 1
}

# User functions
# Test case 01: Test source use, reading variables
# This test case testing b3bp behavior when it sourced by an other sript
# Acceptance: sourcing b3bp and read every non-local, non-changeable variables
test_case_01(){
  info "Test source use, reading variables"
  notice "Accept test, when every variable is readable from sourced script"

  local result=0
  # If run all test case, only first sourcing b3bp with specified language
  if [[ -z "${arg_t}" ]]; then
    # Change localization for proper testing
    LANGUAGE=en_US source b3bp
  else
    source b3bp
  fi

  local vars=( __b3bp_srcd __b3bp_dir __b3bp_file __b3bp_base __b3bp_srcdir 
    __b3bp_srcfile __b3bp_srcbase __b3bp_name __b3bp_short_name
    __b3bp_short_description __b3bp_long_description __b3bp_version 
    __b3bp_revision __b3bp_date __b3bp_license __b3bp_creator __b3bp_publisher
    __b3bp_link __b3bp_usage )

  for var in "${vars[@]}"; do
    debug "${var}: ${!var:-}"
    if [[ -z "${!var:-}" ]]; then
      result=1
      error "Variable ${var} not readable!"
    fi  
  done
  return "${result}"
}

# Test case 02: Test source use, writing variables
# This test case testing b3bp behavior when it sourced by an other sript
# Acceptance: sourcing b3bp and write every non-local, non-changeable variables
test_case_02() {
  info "Test source use, writing variables"
  notice "Accept test, when every variable is writable from sourced script"

  local result=0
  [[ -n "${arg_t}" ]] && source b3bp

  local vars=( __b3bp_srcd __b3bp_dir __b3bp_file __b3bp_base __b3bp_srcdir 
    __b3bp_srcfile __b3bp_srcbase __b3bp_name __b3bp_short_name
    __b3bp_short_description __b3bp_long_description __b3bp_version 
    __b3bp_revision __b3bp_date __b3bp_license __b3bp_creator __b3bp_publisher
    __b3bp_link __b3bp_usage )

  for var in "${vars[@]}"; do
    debug "${var}: ${!var:-}"
    # Generate random 32 character alphanumeric string (upper and lowercase)
    local NEW_UUID=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n 1)
    printf -v "${var}" '%s' "${NEW_UUID}"
    debug "${var}: ${!var}"
    if [[ "${!var}" != "${NEW_UUID}" ]]; then
      result=1
      error "Variable ${var} not writable!"
    fi  
  done
  return "${result}"
}

# Test case 03: Test direct call
# Test b3bp behaviour when calling directly from script or cmd.
# Acceptance: calling b3bp and echoing main function's content
# Side-effect: testing localization, change language
test_case_03(){
  info "Test direct call, reading variables"
  notice "Accept test, if printing main function's content"

  local result=0
  # Change localization for proper testing
  local var=$(LANGUAGE=en_US ./b3bp)
  debug "${var}"
  if [[ "${var}" != *"Hello, world"* ]]; then
    result=1
    error "Return value of called script is not readable!"
  fi
  return "${result}"
}

# Test case 04: Test sourced use with called function
# Test when script is sourced, how can we call a function
# Acceptance: calling main function and returning adequate value
# Side-effect: testing localization, change language
test_case_04() {
  info "Test sourced use with directly called function"
  notice "Accept test, if printing main function's content"

  local result=0
  # Change localization for proper testing
  [[ -n "${arg_t}" ]] && LANGUAGE=en_US source b3bp

  local var=$(main)
  debug "${var}"
  # When source a script, LANGUAGE environmental variable 
  if [[ "${var}" != *"Hello, world"* ]]; then
    result=1
    error "Return value of called function is not readable!"
  fi
  return "${result}"
}

# Test case 05: Testing localization
# Testing script using local language
# Acceptance: calling main function and returning adequate value
test_case_05() {
  info "Test sourced use with directly called function"
  notice "Accept test, if printing main function's content"

  local result=0

  local var=$(./b3bp)
  debug "${var}"
  if [[ "${var}" != *$"Hello, world"* ]]; then
    result=1
    error "Return value of called function is not readable!"
  fi
  return "${result}"
}

# Test case 06: Set usage string externally
# Testing how to set __b3bp_usage string externally and call the script
# Acceptance: call the script and using the externally specified usage string
test_case_06(){
  info "Test externally set usage string"
  notice "Accept test, if __b3bp_usage is the earlier set value"

  local result=0
  
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
  [[ -n "${arg_t}" ]] && LANGUAGE=en_US source b3bp

  debug "${__b3bp_usage}"
  # When source a script, LANGUAGE environmental variable 
  if [[ "${__b3bp_usage}" != "${test_usage}" ]]; then
    result=1
    error "Usage string externally not writable!"
  fi
  return "${result}"
}
# Test case 07: Test long and short arguments
# Testing how to parse short, gnu-long, xfree86-long, dos-short and long style
# arguments from usage string
# Acceptance: call the script and using the externally specified usage string
test_case_07(){
  info "Test long and short arguments "
  notice "Accept test, if __b3bp_usage is the earlier set value"

  local result=0
  
read -r -d '' test_usage <<-'EOF' || true
b3bp [ARGUMENTS] [PARAMETERS]
Available arguments:
  -a  --alpha  Alpha
  --b  Bravo
  /c /charlie  Charlie
  -delta  Delta
  --echo  Echo
  /foxtrot  Foxtrott
EOF

  __b3bp_usage="${test_usage}"
  # Change localization for proper testing
  [[ -n "${arg_t}" ]] && LANGUAGE=en_US source b3bp

  debug "${__b3bp_usage}"
  debug "__b3bp_arg_a: ${__b3bp_arg_a}"
  debug "__b3bp_arg_b: ${__b3bp_arg_b}"
  debug "__b3bp_arg_c: ${__b3bp_arg_c}"
  # When source a script, LANGUAGE environmental variable 
  if [[ "${__b3bp_usage}" != "${test_usage}" ]]; then
    result=1
    error "Usage string externally not writable!"
  fi
  if [[ "${__b3bp_arg_a}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_a don't created!"
  fi
  if [[ "${__b3bp_arg_b}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_b don't created!"
  fi
  if [[ "${__b3bp_arg_c}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_c don't created!"
  fi
  return "${result}"
}

# Test case 08: Usage string parse I: short flags
# Testing how to parse short, gnu-long, xfree86-long, dos-short and long style
# arguments from usage string
# Acceptance: call the script and using the externally specified usage string
test_case_08(){
  info "Test long and short arguments "
  notice "Accept test, if __b3bp_usage is the earlier set value"

  local result=0
  
read -r -d '' test_usage <<-'EOF' || true
b3bp [ARGUMENTS] [PARAMETERS]
Available arguments:
  -a  Alpha
  -b  Bravo
  -c  Charlie
  -d  Delta
  -e  Echo
  -f  Foxtrot
  -g  Golf
  -h  Hotel
  -i  India
  -j  Juliet
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
  -w  Whiskey
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
  [[ -n "${arg_t}" ]] && LANGUAGE=en_US source b3bp

  debug "${__b3bp_usage}"
  debug "__b3bp_arg_a: ${__b3bp_arg_a}"
  debug "__b3bp_arg_b: ${__b3bp_arg_b}"
  debug "__b3bp_arg_c: ${__b3bp_arg_c}"
  debug "__b3bp_arg_d: ${__b3bp_arg_d}"
  debug "__b3bp_arg_e: ${__b3bp_arg_e}"
  debug "__b3bp_arg_f: ${__b3bp_arg_f}"
  debug "__b3bp_arg_g: ${__b3bp_arg_g}"
  debug "__b3bp_arg_h: ${__b3bp_arg_h}"
  debug "__b3bp_arg_i: ${__b3bp_arg_i}"
  debug "__b3bp_arg_j: ${__b3bp_arg_j}"
  debug "__b3bp_arg_k: ${__b3bp_arg_k}"
  debug "__b3bp_arg_l: ${__b3bp_arg_l}"
  debug "__b3bp_arg_m: ${__b3bp_arg_m}"
  debug "__b3bp_arg_n: ${__b3bp_arg_n}"
  debug "__b3bp_arg_o: ${__b3bp_arg_o}"
  debug "__b3bp_arg_p: ${__b3bp_arg_p}"
  debug "__b3bp_arg_q: ${__b3bp_arg_q}"
  debug "__b3bp_arg_r: ${__b3bp_arg_r}"
  debug "__b3bp_arg_s: ${__b3bp_arg_s}"
  debug "__b3bp_arg_t: ${__b3bp_arg_t}"
  debug "__b3bp_arg_u: ${__b3bp_arg_u}"
  debug "__b3bp_arg_v: ${__b3bp_arg_v}"
  debug "__b3bp_arg_w: ${__b3bp_arg_w}"
  debug "__b3bp_arg_x: ${__b3bp_arg_x}"
  debug "__b3bp_arg_y: ${__b3bp_arg_y}"
  debug "__b3bp_arg_z: ${__b3bp_arg_z}"
  debug "__b3bp_arg_0: ${__b3bp_arg_0}"
  debug "__b3bp_arg_1: ${__b3bp_arg_1}"
  debug "__b3bp_arg_2: ${__b3bp_arg_2}"
  debug "__b3bp_arg_3: ${__b3bp_arg_3}"
  debug "__b3bp_arg_4: ${__b3bp_arg_4}"
  debug "__b3bp_arg_5: ${__b3bp_arg_5}"
  debug "__b3bp_arg_6: ${__b3bp_arg_6}"
  debug "__b3bp_arg_7: ${__b3bp_arg_7}"
  debug "__b3bp_arg_8: ${__b3bp_arg_8}"
  debug "__b3bp_arg_9: ${__b3bp_arg_9}"
  # When source a script, LANGUAGE environmental variable 
  if [[ "${__b3bp_usage}" != "${test_usage}" ]]; then
    result=1
    error "Usage string externally not writable!"
  fi
  if [[ "${__b3bp_arg_a}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_a don't created!"
  fi
  if [[ "${__b3bp_arg_b}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_b don't created!"
  fi
  if [[ "${__b3bp_arg_c}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_c don't created!"
  fi
  if [[ "${__b3bp_arg_d}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_d don't created!"
  fi
  if [[ "${__b3bp_arg_e}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_e don't created!"
  fi
  if [[ "${__b3bp_arg_f}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_f don't created!"
  fi
  if [[ "${__b3bp_arg_g}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_g don't created!"
  fi
  if [[ "${__b3bp_arg_h}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_h don't created!"
  fi
  if [[ "${__b3bp_arg_i}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_i don't created!"
  fi
  if [[ "${__b3bp_arg_j}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_j don't created!"
  fi
  if [[ "${__b3bp_arg_k}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_k don't created!"
  fi
  if [[ "${__b3bp_arg_l}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_l don't created!"
  fi
  if [[ "${__b3bp_arg_m}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_m don't created!"
  fi
  if [[ "${__b3bp_arg_n}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_n don't created!"
  fi
  if [[ "${__b3bp_arg_o}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_o don't created!"
  fi
  if [[ "${__b3bp_arg_p}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_p don't created!"
  fi
  if [[ "${__b3bp_arg_q}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_q don't created!"
  fi
  if [[ "${__b3bp_arg_r}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_r don't created!"
  fi
  if [[ "${__b3bp_arg_s}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_s don't created!"
  fi
  if [[ "${__b3bp_arg_t}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_t don't created!"
  fi
  if [[ "${__b3bp_arg_u}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_u don't created!"
  fi
  if [[ "${__b3bp_arg_v}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_v don't created!"
  fi
  if [[ "${__b3bp_arg_w}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_w don't created!"
  fi
  if [[ "${__b3bp_arg_x}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_x don't created!"
  fi
  if [[ "${__b3bp_arg_y}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_y don't created!"
  fi
  if [[ "${__b3bp_arg_z}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_z don't created!"
  fi
  if [[ "${__b3bp_arg_0}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_0 don't created!"
  fi
  if [[ "${__b3bp_arg_1}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_1 don't created!"
  fi
  if [[ "${__b3bp_arg_2}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_2 don't created!"
  fi
  if [[ "${__b3bp_arg_3}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_3 don't created!"
  fi
  if [[ "${__b3bp_arg_4}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_4 don't created!"
  fi
  if [[ "${__b3bp_arg_5}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_5 don't created!"
  fi
  if [[ "${__b3bp_arg_6}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_6 don't created!"
  fi
  if [[ "${__b3bp_arg_7}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_7 don't created!"
  fi
  if [[ "${__b3bp_arg_8}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_8 don't created!"
  fi
  if [[ "${__b3bp_arg_9}" != 0 ]]; then
    result=0
    error "Argument-variable __b3bp_arg_9 don't created!"
  fi
  return "${result}"
}

running_testcase(){
  if [[ -n "$(type -t ${1})" ]] && [[ "$(type -t ${1})" = function ]]; then
    info "${1} started"
    echo "====================================================================="
    time {
      if ${1}; then
        info "${1} OK!"
      else
        error "${1} FAIL!"
      fi
    }
    echo "====================================================================="
  else
    warning "No such test case: ${1}!"
  fi
}
### Parse commandline options
##############################################################################

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
# - A short option must be preset for every long option; but every short option
#   need not have a long option
# - `--` is respected as the separator between options and arguments
# - We do not bash-expand defaults, so setting '~/app' as a default will not resolve to ${HOME}.
#   you can use bash variables to work around this (so use ${HOME} instead)

# shellcheck disable=SC2015
[[ "${__usage+x}" ]] || read -r -d '' __usage <<-'EOF' || true # exits non-zero when EOF encountered
  -t --test  [arg] Running the specified test-case
  -v --verbose     Enable verbose mode, print script as it is executed
  -d --debug       Enables debug mode
  -h --help        This page
EOF

# shellcheck disable=SC2015
[[ "${__helptext+x}" ]] || read -r -d '' __helptext <<-'EOF' || true # exits non-zero when EOF encountered
  Acceptance test-script for BASH4 Boilerplate.
EOF

# Translate usage string -> getopts arguments, and set $arg_<flag> defaults
while read -r __b3bp_tmp_line; do
  if [[ "${__b3bp_tmp_line}" =~ ^- ]]; then
    # fetch single character version of option string
    __b3bp_tmp_opt="${__b3bp_tmp_line%% *}"
    __b3bp_tmp_opt="${__b3bp_tmp_opt:1}"

    # fetch long version if present
    __b3bp_tmp_long_opt=""

    if [[ "${__b3bp_tmp_line}" = *"--"* ]]; then
      __b3bp_tmp_long_opt="${__b3bp_tmp_line#*--}"
      __b3bp_tmp_long_opt="${__b3bp_tmp_long_opt%% *}"
    fi

    # map opt long name to+from opt short name
    printf -v "__b3bp_tmp_opt_long2short_${__b3bp_tmp_long_opt//-/_}" '%s' "${__b3bp_tmp_opt}"
    printf -v "__b3bp_tmp_opt_short2long_${__b3bp_tmp_opt}" '%s' "${__b3bp_tmp_long_opt//-/_}"

    # check if option takes an argument
    if [[ "${__b3bp_tmp_line}" =~ \[.*\] ]]; then
      __b3bp_tmp_opt="${__b3bp_tmp_opt}:" # add : if opt has arg
      __b3bp_tmp_init=""  # it has an arg. init with ""
      printf -v "__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}" '%s' "1"
    elif [[ "${__b3bp_tmp_line}" =~ \{.*\} ]]; then
      __b3bp_tmp_opt="${__b3bp_tmp_opt}:" # add : if opt has arg
      __b3bp_tmp_init=""  # it has an arg. init with ""
      # remember that this option requires an argument
      printf -v "__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}" '%s' "2"
    else
      __b3bp_tmp_init="0" # it's a flag. init with 0
      printf -v "__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}" '%s' "0"
    fi
    __b3bp_tmp_opts="${__b3bp_tmp_opts:-}${__b3bp_tmp_opt}"
  fi

  [[ "${__b3bp_tmp_opt:-}" ]] || continue

  if [[ "${__b3bp_tmp_line}" =~ (^|\.\ *)Default= ]]; then
    # ignore default value if option does not have an argument
    __b3bp_tmp_varname="__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}"

    if [[ "${!__b3bp_tmp_varname}" != "0" ]]; then
      __b3bp_tmp_init="${__b3bp_tmp_line##*Default=}"
      __b3bp_tmp_re='^"(.*)"$'
      if [[ "${__b3bp_tmp_init}" =~ ${__b3bp_tmp_re} ]]; then
        __b3bp_tmp_init="${BASH_REMATCH[1]}"
      else
        __b3bp_tmp_re="^'(.*)'$"
        if [[ "${__b3bp_tmp_init}" =~ ${__b3bp_tmp_re} ]]; then
          __b3bp_tmp_init="${BASH_REMATCH[1]}"
        fi
      fi
    fi
  fi

  if [[ "${__b3bp_tmp_line}" =~ (^|\.\ *)Required\. ]]; then
    # remember that this option requires an argument
    printf -v "__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}" '%s' "2"
  fi

  printf -v "arg_${__b3bp_tmp_opt:0:1}" '%s' "${__b3bp_tmp_init}"
done <<< "${__usage:-}"

# run getopts only if options were specified in __usage
if [[ "${__b3bp_tmp_opts:-}" ]]; then
  # Allow long options like --this
  __b3bp_tmp_opts="${__b3bp_tmp_opts}-:"

  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  # start parsing command line
  set +o nounset # unexpected arguments will cause unbound variables
                 # to be dereferenced
  # Overwrite $arg_<flag> defaults with the actual CLI options
  while getopts "${__b3bp_tmp_opts}" __b3bp_tmp_opt; do
    [[ "${__b3bp_tmp_opt}" = "?" ]] && help "Invalid use of script: ${*} "

    if [[ "${__b3bp_tmp_opt}" = "-" ]]; then
      # OPTARG is long-option-name or long-option=value
      if [[ "${}" =~ .*=.* ]]; then
        # --key=value format
        __b3bp_tmp_long_opt=${OPTARG/=*/}
        # Set opt to the short option corresponding to the long option
        __b3bp_tmp_varname="__b3bp_tmp_opt_long2short_${__b3bp_tmp_long_opt//-/_}"
        printf -v "__b3bp_tmp_opt" '%s' "${!__b3bp_tmp_varname}"
        OPTARG=${OPTARG#*=}
      else
        # --key value format
        # Map long name to short version of option
        __b3bp_tmp_varname="__b3bp_tmp_opt_long2short_${OPTARG//-/_}"
        printf -v "__b3bp_tmp_opt" '%s' "${!__b3bp_tmp_varname}"
        # Only assign OPTARG if option takes an argument
        __b3bp_tmp_varname="__b3bp_tmp_has_arg_${__b3bp_tmp_opt}"
        printf -v "OPTARG" '%s' "${@:OPTIND:${!__b3bp_tmp_varname}}"
        # shift over the argument if argument is expected
        ((OPTIND+=__b3bp_tmp_has_arg_${__b3bp_tmp_opt}))
      fi
      # we have set opt/OPTARG to the short value and the argument as OPTARG if it exists
    fi
    __b3bp_tmp_varname="arg_${__b3bp_tmp_opt:0:1}"
    __b3bp_tmp_default="${!__b3bp_tmp_varname}"

    __b3bp_tmp_value="${OPTARG}"
    if [[ -z "${OPTARG}" ]] && [[ "${__b3bp_tmp_default}" = "0" ]]; then
      __b3bp_tmp_value="1"
    fi

    printf -v "${__b3bp_tmp_varname}" '%s' "${__b3bp_tmp_value}"
    debug "cli arg ${__b3bp_tmp_varname} = (${__b3bp_tmp_default}) -> ${!__b3bp_tmp_varname}"
  done
  set -o nounset # no more unbound variable references expected

  shift $((OPTIND-1))

  if [[ "${1:-}" = "--" ]] ; then
    shift
  fi
fi


### Automatic validation of required option arguments
##############################################################################

for __b3bp_tmp_varname in ${!__b3bp_tmp_has_arg_*}; do
  # validate only options which required an argument
  [[ "${!__b3bp_tmp_varname}" = "2" ]] || continue

  __b3bp_tmp_opt_short="${__b3bp_tmp_varname##*_}"
  __b3bp_tmp_varname="arg_${__b3bp_tmp_opt_short}"
  [[ "${!__b3bp_tmp_varname}" ]] && continue

  __b3bp_tmp_varname="__b3bp_tmp_opt_short2long_${__b3bp_tmp_opt_short}"
  printf -v "__b3bp_tmp_opt_long" '%s' "${!__b3bp_tmp_varname}"
  [[ "${__b3bp_tmp_opt_long:-}" ]] && __b3bp_tmp_opt_long=" (--${__b3bp_tmp_opt_long//_/-})"

  help "Option -${__b3bp_tmp_opt_short}${__b3bp_tmp_opt_long:-} requires an argument"
done


### Cleanup Environment variables
##############################################################################

for __tmp_varname in ${!__b3bp_tmp_*}; do
  unset -v "${__tmp_varname}"
done

unset -v __tmp_varname


### Externally supplied __usage. Nothing else to do here
##############################################################################

if [[ "${__b3bp_external_usage:-}" = "true" ]]; then
  unset -v __b3bp_external_usage
  return
fi


### Signal trapping and backtracing
##############################################################################

function __b3bp_cleanup_before_exit () {
  info "Cleaning up. Done"
}
#trap __b3bp_cleanup_before_exit EXIT

# requires `set -o errtrace`
__b3bp_err_report() {
    local error_code
    error_code=${?}
    error "Error in ${__file} in function ${1} on line ${2}"
    exit ${error_code}
}
# Uncomment the following line for always providing an error backtrace
# trap '__b3bp_err_report "${FUNCNAME:-.}" ${LINENO}' ERR


### Command-line argument switches (like -d for debugmode, -h for showing helppage)
##############################################################################

# debug mode
if [[ "${arg_d:?}" = "1" ]]; then
  set -o xtrace
  LOG_LEVEL="7"
  # Enable error backtracing
  trap '__b3bp_err_report "${FUNCNAME:-.}" ${LINENO}' ERR
fi

# verbose mode
if [[ "${arg_v:?}" = "1" ]]; then
  set -o verbose
fi

# help mode
if [[ "${arg_h:?}" = "1" ]]; then
  # Help exists with code 1
  help "Help using ${0}"
fi


### Validation. Error out if the things required for your script are not present
##############################################################################

[[ "${LOG_LEVEL:-}" ]] || emergency "Cannot continue without LOG_LEVEL. "


### Runtime
##############################################################################
# Starting testcases
if [[ -z "${arg_t}" ]]; then
  info "Running all test cases"
  echo "======================================================================="
  for ((i=1; i<=10; i++ )) ;do  
    printf -v "num" '%02d\n' "$i"
    test_case="test_case_${num}" 
    if [[ -n "$(type -t ${test_case})" ]] && [[ "$(type -t ${test_case})" = function ]]; then
      running_testcase "${test_case}"
    fi
  done
else
  test_cases=( ${arg_t//,/ } )
  for test_case in "${test_cases[@]}"; do
    running_testcase "${test_case}"
  done
fi
