#!/usr/bin/env bash
function change_locale() {
local profile=${1:-EN}

  case ${profile} in
    DE|de|DE_DE|de_DE)
      LC_ALL="de_DE.UTF-8"
      LANG="de_DE.UTF-8"
      LANGUAGE="de_DE:de:en_US:en"
      ;;
    EN|en|EN_US|en_US)
      LC_ALL="en_US.UTF-8"
      LANG="en_US.UTF-8"
      LANGUAGE="en_US:en"
      ;;
    HU|hu|HU_HU|hu_HU)
      LC_ALL="hu_HU.UTF-8"
      LANG="hu_HU.UTF-8"
      LANGUAGE="hu_HU:hu"
      ;;
    *)
      if [[ -n "$(type -t error)" && "$(type -t error)" = function ]]; then 
        error "ALERT" "${FUNCNAME}: unknown profile '${profile}'"
      else
        echo "ALERT" "${FUNCNAME}: unknown profile '${profile}'"
      fi

      #echo "ALERT" "${FUNCNAME}: unknown profile '${profile}'"
      ;;
    esac

    if [[ -n "$(type -t info)" && "$(type -t info)" = function ]]; then 
      info "Locale settings change to ${LANG}"
    else
      echo "Locale settings change to ${LANG}"
    fi

    export LC_ALL LANG LANGUAGE
}
