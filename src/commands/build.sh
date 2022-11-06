

parser_definition_build_debug() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy-fetch [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_build_debug() {
  eval "$(getoptions parser_definition_build_debug parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"
  echo "BUILD_TARGET: $BUILD_TARGET"

  exec_legacy_build

  if [ $BUILD_TARGET = "debug" ]; then
    exec_build_debug "$@"
  else
    exec_build_dist "$@"
  fi

  echo "Build complete."
}
