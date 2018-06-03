#!/usr/bin/env bash
#===============================================================================
# Display Information library (display_info)
# Licensed under the MIT license
#
# Displaying help and versioninformation
# 
# Copyright (c) 2018 Krisztián Mukli
# https://www.github.com/krisztianmukli/bash3boilerplate
#
# Notes
#-------------------------------------------------------------------------------
# Quickstart
# Setup information
# Changelog
# ToDo
# Known bugs
#
# Based on BASH4 Boilerplate 20170818-dev and BASH3 Boilerplate v2.3.0
#===============================================================================

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
