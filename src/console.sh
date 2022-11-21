
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
  console_print "${ESCAPE}[1;36m$(console_pad "$1" 12)${ESCAPE}[0m" "$2"
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

console_print() {
  echo -e "$1 $2" >&2
}
