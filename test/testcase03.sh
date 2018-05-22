#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
source ../log.sh

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case 03: Test direct call"
echo "Test behaviour when calling directly from script or cmd."
echo "Acceptance: calling b3bp and echoing main functions "
# Start testcase
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase
# Change localization for proper testing
var=$(../b3bp -f test)

# Start validation
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

debug "${var}"
if [[ "${var}" != *"BASH3 Boilerplate"* ]]; then
  result=1
  error "Return value of called script is not readable!"
fi

# Print results
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
