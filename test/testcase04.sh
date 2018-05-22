#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
source ../log.sh

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
