
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

console_print() {
  if [ -z "${QUIET}" ]; then
    printf "$1 $2\n" >&2
  fi
}

console_log() {
  console_print "${ESCAPE}[1;39m$1${ESCAPE}[0m" "$2"
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

console_hint() {
  printf "${ESCAPE}[1;39m$1${ESCAPE}[0m\n" >&2
}

console_error() {
  printf "${ESCAPE}[1;31merror${ESCAPE}[0m: $1\n" >&2
}

console_error_code() {
  printf "${ESCAPE}[1;31merror[$1]${ESCAPE}[1;39m: $2${ESCAPE}[0m\n" >&2
}
