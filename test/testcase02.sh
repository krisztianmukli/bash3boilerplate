#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test case 02: Test source use, writing variables"
echo "This test case testing b4bp behavior when it sourced by an other sript"
echo "Acceptance: sourcing b4bp and write every non-local, non-changeable variables"

printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"

result=0
source ../b3bp -f test

vars=( __b3bp_srcd __b3bp_dir __b3bp_file __b3bp_base __b3bp_usage __b3bp_arg_f
__b3bp_arg_d __b3bp_arg_v __b3bp_arg_h )

for var in "${vars[@]}"; do
  debug "${var}: ${!var:-}"
  # Generate random 32 character alphanumeric string (upper and lowercase)
  printf -v "${var}" '%s' "test data"
  debug "${var}: ${!var}"
  if [[ "${!var}" != "test data" ]]; then
    result=1
    error "Variable ${var} not writable!"
  fi  
done

printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

if [[ "${result}" == 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
