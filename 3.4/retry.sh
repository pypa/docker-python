#!/bin/bash

ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_RESET="\033[0m"
ANSI_CLEAR="\033[0K"

retry() {
  local result=0
  local count=1
  while [ $count -le 10 ]; do
    [ $result -ne 0 ] && {
      echo -e "\n${ANSI_RED}The command \"$@\" failed. Retrying, $count of 10.${ANSI_RESET}\n" >&2
    }
    "$@"
    result=$?
    [ $result -eq 0 ] && break
    count=$(($count + 1))
    sleep 5
  done

  [ $count -gt 10 ] && {
    echo -e "\n${ANSI_RED}The command \"$@\" failed 10 times.${ANSI_RESET}\n" >&2
  }

  return $result
}

retry $*
