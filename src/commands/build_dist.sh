

parser_definition_legacy_fetch() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy-fetch [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_debug_build() {
  eval "$(getoptions parser_definition_debug_build parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_name=$(basename $1)
    echo "$i Downloading '$module_name' from $1"
    curl -sL $1 -o target/debug/legacy/$module_name
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}
