#!/usr/bin/env bash
#===============================================================================
# Parse url (parse_url.sh)
#
# Takes a URL and parses protocol, user, pass, host, port, path.
# Based on:
#
#  - http://stackoverflow.com/a/6174447/151666
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
#  source parse_url.sh
#  parse_url 'http://johndoe:abc123@example.com:8080/index.html' pass
#
# Usage as a command:
#
#  parse_url.sh 'http://johndoe:abc123@example.com:8080/index.html'
#
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
# parse_url: Takes a URL and parses protocol, user, pass, host, port, path
# Arguments:
#   parse_url url [returnvalue]
# Returns:
#   if specified returnvalue, parse_url echoing that 1 variable, otherwise 
# echoing all parsed values
#-------------------------------------------------------------------------------
function parse_url() {
  local parse="${1}"
  local need="${2:-}"

  local proto
  local url
  local userpass
  local user
  local pass
  local hostport
  local host
  local port
  local path

  proto="$(echo "${parse}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  url="${parse/${proto}/}"
  userpass="$(echo "${url}" | grep @ | cut -d@ -f1)"
  user="$(echo "${userpass}" | grep : | cut -d: -f1)"
  pass="$(echo "${userpass}" | grep : | cut -d: -f2)"
  hostport="$(echo "${url/${userpass}@/}" | cut -d/ -f1)"
  host="$(echo "${hostport}" | grep : | cut -d: -f1)"
  port="$(echo "${hostport}" | grep : | cut -d: -f2)"
  path="$(echo "${url}" | grep / | cut -d/ -f2-)"

  [[ ! "${user}" ]] && user="${userpass}"
  [[ ! "${host}" ]] && host="${hostport}"
  if [[ ! "${port}" ]]; then
    [[ "${proto}" = "http://" ]]  && port="80"
    [[ "${proto}" = "https://" ]] && port="443"
    [[ "${proto}" = "mysql://" ]] && port="3306"
    [[ "${proto}" = "redis://" ]] && port="6379"
  fi

  if [[ "${need}" ]]; then
    echo "${!need}"
  else
    echo ""
    echo " Use second argument to return just 1 variable."
    echo " parse_url() demo: "
    echo ""
    echo "   proto: ${proto}"
    echo "   user:  ${user}"
    echo "   pass:  ${pass}"
    echo "   host:  ${host}"
    echo "   port:  ${port}"
    echo "   path:  ${path}"
    echo ""
  fi
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f parse_url
else
  parse_url "${@}"
  exit ${?}
fi

#===============================================================================
# END OF FILE
#===============================================================================
