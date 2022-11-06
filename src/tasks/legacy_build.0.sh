
legacy_build_run() {
  eval "$(getoptions parser_definition_legacy_download parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    echo "$i: $1"
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}
