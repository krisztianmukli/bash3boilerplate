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
  __testcase08_srcd=1
  if [[ "${__testcase08_usage+x}" ]]; then
    [[ "${BASH_SOURCE[1]}" = "${0}" ]] && __testcase08_srcd=0
    __testcase08_external_usage=1
    __testcase08_tmp_surce_idx=1
  fi 
else
  __testcase08_srcd=0
  [[ "${__testcase08_usage+x}" ]] && unset -v __testcase08_usage
  [[ "${__testcase08_helptext+x}" ]] && unset -v __testcase08_helptext
fi
__testcase08_dir="$(cd "$(dirname "${BASH_SOURCE[${__testcase08_tmp_source_idx:-0}]}")" && pwd)"
__testcase08_file="${__testcase08_dir}/$(basename "${BASH_SOURCE[${__testcase08_tmp_source_idx:-0}]}")"
__testcase08_base="$(basename "${__testcase08_file}" .sh)"

LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

#-------------------------------------------------------------------------------
# Sourced files 
#-------------------------------------------------------------------------------
export PATH="${__testcase08_dir}/lib:${HOME}/.local/share/${__testcase08_base}:$PATH"
source log.sh
source ini_val.sh

#-------------------------------------------------------------------------------
# Test case description
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Test Case 08: Testing ini_val.sh"
echo "Creating, setting and reading ini-file, with ini_val.sh"
echo "Acceptance:"
echo "1. Creating ini-file"
echo "2. Setting some initial value to ini-file"
echo "3. Reading values from file"
echo "4. Overwriting some value and re-reading"

#-------------------------------------------------------------------------------
# Start testcase
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase
[[ -e testcase08.ini ]] && rm -f testcase08.ini
ini_val testcase08.ini connection.host 192.168.1.1
[[ ! -e testcase08.ini ]] && result=1

ini_val testcase08.ini connection.client 192.168.1.100
ini_val testcase08.ini connection.timeout 10000
ini_val testcase08.ini server.license GNU
ini_val testcase08.ini server.maxusers 10
ini_val testcase08.ini client.autostart 1

connectionclient=$(ini_val testcase08.ini connection.client)
connectiontimeout=$(ini_val testcase08.ini connection.timeout)
serverlicense=$(ini_val testcase08.ini server.license)
servermaxusers=$(ini_val testcase08.ini server.maxusers)
clientautostart=$(ini_val testcase08.ini client.autostart)

if [[ "${connectionclient}" != "192.168.1.100" ]]; then result=1; error "connectionclient: ${connectionclient}"; fi
if [[ "${connectiontimeout}" != "10000" ]]; then result=1; error "connectiontimeout: ${connectiontimeout}"; fi
if [[ "${serverlicense}" != "GNU" ]]; then result=1; error "serverlicense: ${serverlicense}"; fi
if [[ "${servermaxusers}" != "10" ]]; then result=1; error "servermaxuser: ${servermaxusers}"; fi
if [[ "${clientautostart}" != "1" ]]; then result=1; error "clientautostart: ${clientautostart}"; fi

ini_val testcase08.ini connection.client 192.168.155.10
ini_val testcase08.ini connection.timeout 9876
ini_val testcase08.ini server.license COPYRIGHT
ini_val testcase08.ini server.maxusers 999
ini_val testcase08.ini client.autostart 0

connectionclient=$(ini_val testcase08.ini connection.client)
connectiontimeout=$(ini_val testcase08.ini connection.timeout)
serverlicense=$(ini_val testcase08.ini server.license)
servermaxusers=$(ini_val testcase08.ini server.maxusers)
clientautostart=$(ini_val testcase08.ini client.autostart)

if [[ "${connectionclient}" != "192.168.155.10" ]]; then result=1; error "connectionclient: ${connectionclient}"; fi
if [[ "${connectiontimeout}" != "9876" ]]; then result=1; error "connectiontimeout: ${connectiontimeout}"; fi
if [[ "${serverlicense}" != "COPYRIGHT" ]]; then result=1; error "serverlicense: ${serverlicense}"; fi
if [[ "${servermaxusers}" != "999" ]]; then result=1; error "servermaxuser: ${servermaxusers}"; fi
if [[ "${clientautostart}" != "0" ]]; then result=1; error "clientautostart: ${clientautostart}"; fi

#-------------------------------------------------------------------------------
# Start validation
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"
rm -f testcase08.ini
#-------------------------------------------------------------------------------
# Print results
#-------------------------------------------------------------------------------
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
