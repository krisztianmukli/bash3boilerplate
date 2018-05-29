#!/usr/bin/env bash

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
