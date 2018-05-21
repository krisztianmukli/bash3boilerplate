#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case 01: Test source use, reading variables"
echo "This test case testing b3bp behavior when it sourced by an other sript"
echo "Acceptance: sourcing b3bp and read every non-local, non-changeable variables"

printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"

result=0
source ../b3bp -f test

printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"
vars=( __b3bp_srcd __b3bp_dir __b3bp_file __b3bp_base __b3bp_usage )
for var in "${vars[@]}"; do
  debug "${var}: ${!var:-}"
  if [[ -z "${!var:-}" ]]; then
    result=1
    error "Variable ${var} not readable!"
  fi  
done

printf "%80s\n" | tr " " "-"

if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
