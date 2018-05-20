#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case XX: What testing in this testcase"
echo "Description of test case"
echo "Acceptance: acceptance conditions"
# Start testcase
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase

# Start validation
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

# Print results
printf "%80s\n" | tr " " "-"
if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
