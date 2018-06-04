#!/usr/bin/env bash
#===============================================================================
# Display Information library (display_info)
# Licensed under the MIT license
#
# Displaying help and versioninformation
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
# Setup information
# Changelog
# ToDo
# Known bugs and limitations
#
# Based on BASH4 Boilerplate 20170818-dev and BASH3 Boilerplate v2.3.0
#===============================================================================
# Functions section
#===============================================================================

#-------------------------------------------------------------------------------
# display_info: Showing texts
# Arguments:
#   display_info header maintext footer
# Returns:
#   exit 1
#-------------------------------------------------------------------------------
function display_info() {
local header="${1:-}"
local main="${2:-}"
local footer="${3:-}"

  echo "" 1>&2
  if [[ "${header:-}" ]]; then
    echo " ${header}" 1>&2
    echo "" 1>&2
  fi
  echo "  ${main:-No info available}" 1>&2
  echo "" 1>&2
 
  if [[ "${footer:-}" ]]; then
    echo " ${footer}" 1>&2
    echo "" 1>&2
  fi

  exit 1
}

#===============================================================================
# END OF FILE
#===============================================================================
