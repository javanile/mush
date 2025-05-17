#!/usr/bin/env bash
## BP010: Release metadata
## @build_type: lib
## @build_date: 2025-05-17T20:43:36Z
set -e
use() { return 0; }
extern() { return 0; }
legacy() { return 0; }
module() { return 0; }
public() { return 0; }
embed() { return 0; }
inject() { return 0; }
## BP004: Compile the entrypoint

# FATAL
# ERROR
# WARNING
# INFO
# DEBUG
# TRACE
# SUCCESS

case "$(uname -s)" in
  Darwin*)
    ESCAPE='\x1B'
    ;;
  Linux|*)
    ESCAPE='\e'
    ;;
esac

#CONSOLE_INDENT="${ESCAPE}[1;33m{Mush}${ESCAPE}[0m"

console_pad() {
  [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"
}

console_log() {
  console_print "$1" "$2"
}

console_info() {
  if [ "${VERBOSE}" -gt "0" ]; then
    console_print "${ESCAPE}[1;36m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
  fi
}

console_warning() {
  console_print "${ESCAPE}[1;33m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
}

console_status() {
  console_print "${ESCAPE}[1;32m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
}

console_error() {
  echo -e "${ESCAPE}[1;31merror${ESCAPE}[0m: $1" >&2
}

console_error_code() {
  echo -e "${ESCAPE}[1;31merror[$1]${ESCAPE}[1;39m: $2${ESCAPE}[0m" >&2
}

console_hint() {
  echo -e "${ESCAPE}[1;39m$1${ESCAPE}[0m" >&2
}

console_print() {
  if [ -z "${QUIET}" ]; then
    echo -e "$1 $2" >&2
  fi
}
