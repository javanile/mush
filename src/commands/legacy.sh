
parser_definition_legacy() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_legacy() {
  eval "$(getoptions parser_definition_legacy parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  echo "GLOBAL: $GLOBAL"
  i=0
  while [ $# -gt 0 ] && i=$((i + 1)); do
    module_name=$(basename $1)
    module_file=target/debug/legacy/$module_name
    echo "$i Downloading '$module_name' from $1"
    curl -sL $1 -o $module_file
    chmod +x $module_file
    shift
  done

  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions -o target/debug/legacy/getoptions
  #curl -sL https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/gengetoptions -o target/debug/legacy/gengetoptions
}
