#!/usr/bin/env bash

function mktempfile() {
local pattern="${1:-}"
  
  [[ ! -z "${pattern}" ]] && pattern="/tmp/${pattern}.XXXX"

  echo mktemp "${pattern:-}" "${suffix:-}"
}

function mktempdir() {
local pattern="${1:-}"
  
  [[ ! -z "${pattern}" ]] && pattern="/tmp/${pattern}.XXXX"

  echo mktemp -d "${pattern:-}" "${suffix:-}"
}

 #function cleantemp
