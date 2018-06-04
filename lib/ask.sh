#!/usr/bin/env bash
#===============================================================================
# Simple question library (ask.sh)
#
# Simple choice question with default value
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
# ask: Asking a simple choice question from user and wait for answer
# Arguments:
#   ask question default
# Returns:
#   return 1, if answer is Yes
#   return 0, if answer is No
#-------------------------------------------------------------------------------
ask() {
local prompt default reply

  while true; do

   if [ "${2:-}" = "Y" ]; then
     prompt="Y/n"
     default=Y
   elif [ "${2:-}" = "N" ]; then
     prompt="y/N"
     default=N
   else
     prompt="y/n"
     default=
   fi

   # Ask the question (not using "read -p" as it uses stderr not stdout)
   echo -n "$1 [$prompt] "

   # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
   read reply </dev/tty

   # Default?
   if [ -z "$reply" ]; then
     reply=$default
   fi

   # Check if the reply is valid
   case "$reply" in
     Y*|y*) return 0 ;;
     N*|n*) return 1 ;;
   esac

 done
}

#===============================================================================
# END OF FILE
#===============================================================================
