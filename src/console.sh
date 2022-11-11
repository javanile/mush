
# FATAL
# ERROR
# WARNING
# INFO
# DEBUG
# TRACE

case "$(uname -s)" in
  Darwin*)
    ESCAPE='\x1B'
    ;;
  Linux|*)
    ESCAPE='\e'
    ;;
esac

CONSOLE_INDENT="${ESCAPE}[1;33m{Mush}${ESCAPE}[0m"

console_log() {
  console_echo "$1"
}

console_info() {
  console_echo "$1"
}

console_error() {
  console_echo "${ESCAPE}[1;31m$1${ESCAPE}[0m"
}

console_done() {
  console_echo "${ESCAPE}[1;32m$1${ESCAPE}[0m"
}

console_echo() {
  echo -e "${CONSOLE_INDENT} $1"
  CONSOLE_INDENT='      '
}
