#!/usr/bin/env bash
#===============================================================================
# Reading and writing .ini files (ini_val.sh)
# Licensed under the MIT license
#
# This file, can read and write .ini files using pure bash
# 
# The MIT License (MIT)
# Copyright (c) 2018 Krisztián Mukli
# https://www.github.com/krisztianmukli/bash3boilerplate
#
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.
#
# Notes
#-------------------------------------------------------------------------------
# Quickstart
#
# Usage as a function:
#
#  source ini_val.sh
#  ini_val data.ini connection.host 127.0.0.1
#
# Usage as a command:
#
#  ini_val.sh data.ini connection.host 127.0.0.1
#
# Setup information
# Changelog
# ToDo
# Known bugs and limitations
# * All keys inside the .ini file must be unique, regardless of the use of sections
#
# Based on BASH4 Boilerplate 20170818-dev and BASH3 Boilerplate v2.3.0
#===============================================================================
# Functions section
#===============================================================================

#-------------------------------------------------------------------------------
# ini_val: Read and write .ini file
# Arguments:
#   ini_val inifile section[.key] [value]
# - section.key separation is optional
# - read value if not sepcified, otherwise write it
# Returns:
#   exit 1, if not sourced
#-------------------------------------------------------------------------------
function ini_val() {
  local file="${1:-}"
  local sectionkey="${2:-}"
  local val="${3:-}"
  local delim=" = "
  local section=""
  local key=""

  # Split on . for section. However, section is optional
  IFS='.' read -r section key <<< "${sectionkey}"
  if [[ ! "${key}" ]]; then
    key="${section}"
    section=""
  fi

  local current
  #current=$(awk -F "${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")

  if [[ ! "${val}" ]]; then
    if [[ -e "${file}" && -r "${file}" ]]; then
      # get a value
      current=$(awk -F "${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")
      echo "${current}"
    fi
  else
    if [[ ! -e "${file}" ]]; then 
      touch "${file}"
    else
      current=$(awk -F "${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")
    fi
    # set a value
    if [[ ! "${current:-}" ]]; then
      # doesn't exist yet, add

      if [[ ! "${section}" ]]; then
        # no section was given, add to bottom of file
        echo "${key}${delim}${val}" >> "${file}"
      else
        if ! grep -Fxq "[${section}]" "${file}"; then
          if [[ -s "${file}" ]]; then
            echo -e "\n[${section}]" >> "${file}"
          else
            echo -e "[${section}]" >> "${file}"
          fi
        fi
        # add to section
        sed -i.bak -e "/\\[${section}\\]/a ${key}${delim}${val}" "${file}"
        # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
        rm -f "${file}.bak"
      fi
    else
      # replace existing
      sed -i.bak -e "/^${key}${delim}/s/${delim}.*/${delim}${val}/" "${file}"
      # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
      rm -f "${file}.bak"
    fi
  fi
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f ini_val
else
  ini_val "${@}"
  exit ${?}
fi

#===============================================================================
# END OF FILE
#===============================================================================
