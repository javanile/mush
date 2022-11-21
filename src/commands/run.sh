
parser_definition_run() {
	setup   REST help:usage abbr:true -- "Run a binary or example of the local package" ''

  msg   -- 'USAGE:' "  ${2##*/} run [OPTIONS] [--] [args]..." ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_run() {
  eval "$(getoptions parser_definition_run parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  exec_legacy_build

  exec_build_debug "$@"

  bin_file=target/debug/$MUSH_PACKAGE_NAME

  console_status "Compiling" "'${bin_file}'"

  compile_file "src/main.sh"

  console_status "Running" "'${bin_file}'"

  exec "$bin_file"
}
