#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace
LOG_LEVEL="${LOG_LEVEL:-7}" # 7 = debug -> 0 = emergency
source ../log.sh

function _configure_locale() { # [profile]
    local profile=${1:-EN}
    case ${profile} in
      DE|DE_DE|de_DE)
          LC_ALL="de_DE.UTF-8"
          LANG="de_DE.UTF-8"
          LANGUAGE="de_DE:de:en_US:en"
          ;;
      EN|EN_US|en|en_US)
          LC_ALL="en_US.UTF-8"
          LANG="en_US.UTF-8"
          LANGUAGE="en_US:en"
          ;;
      HU|HU_HU|hu|hu_HU)
	  LC_ALL="hu_HU.UTF-8"
	  LANG="hu_HU.UTF-8"
	  LANGUAGE="hu_HU:hu"
	  ;;
      *)
          echo "ALERT" "${FUNCNAME}: unknown profile '${profile}'"
          ;;
      esac
      LC_PAPER="de_DE.UTF-8"; # independent from locale
      LESSCHARSET="utf-8";    # independent from locale
      MM_CHARSET="utf-8"      # independent from locale
      echo "locale settings" "${LANG}";
      export LC_ALL LANG LANGUAGE LC_PAPER LESSCHARSET MM_CHARSET
}

# Test case description
printf "%80s\n" | tr " " "-"
echo "Test Case 06: testing localization - sourced use"
echo "Test how to behaviour b3bp in a localized environment with sourced use"
echo "Acceptance: messages in the specified languages"
# Start testcase
printf "%80s\n" | tr " " "-"
echo "Start testcase"
printf "%80s\n" | tr " " "-"
result=0

# Steps of testcase
_configure_locale hu
hu_output=$(source ../b3bp -f test && main)
#| while IFS= read -r line 
#do
#  hu_output="$line"
#done

[[ "${__b3bp_usage+x}" ]] && unset -v __b3bp_usage
_configure_locale en
en_output=$(source ../b3bp -f test && main)
#| while IFS= read -r line 
#do
#  en_output="$line"
#done

# Start validation
printf "%80s\n" | tr " " "-"
echo "Start validation"
printf "%80s\n" | tr " " "-"

echo "${hu_output:-}"
echo "${en_output:-}"
if [[ "${hu_output}" != *"Demó és a Bash-szkript sablon tesztelése"* ]]; then
  result=1
fi

if [[ "${en_output}" != *"Demo and test of the Bash-script template"* ]]; then
  result=1
fi

# Print results
printf "%80s\n" | tr " " "-"
if [[ "${result}" = 0 ]]; then
  info "Test PASSED."
else
  error "Test FAILED!"
fi
