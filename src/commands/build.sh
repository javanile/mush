
parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  #echo "MUSH_PACKAGE_NAME: $MUSH_PACKAGE_NAME"

  exec_legacy_build

  if [ "$BUILD_TARGET" = "dist" ]; then
    exec_build_dist "$@"
  else
    exec_build_debug "$@"
  fi
}
