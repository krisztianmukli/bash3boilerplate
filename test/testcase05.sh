#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
source ../log.sh

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case 05: testing localization"
echo "Test how to behaviour b3bp in a localized environment with direct call"
echo "Acceptance: messages in the specified languages"
# Start testcase
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase
en=$( LANGUAGE=en ../b3bp -f test )
hu=$( LANGUAGE=hu ../b3bp -f test )

# Start validation
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

echo "${en}"
if [[ "${en}" != *"Demo and test of the Bash-script template"* ]]; then
  result=1
fi

echo "${hu}"
if [[ "${hu}" != *"Demó és a Bash-szkript sablon tesztelése"* ]]; then
  result=1
fi

# Print results
printf "%80s\n" | tr " " "-"
if [[ "${result}" = 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
