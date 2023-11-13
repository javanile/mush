
parser_definition_publish() {
	setup   REST help:usage abbr:true -- "Package and upload this package to the registry" ''

  msg     -- 'USAGE:' "  ${2##*/} publish [OPTIONS]" ''

	msg     -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	flag    ALLOW_DIRTY  --allow-dirty  -- "Build artifacts in release mode, with optimizations"
	param   MODULE_NAME  -n --name

	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_publish() {
  eval "$(getoptions parser_definition_publish parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  echo "ALLOW_DIRTY: $ALLOW_DIRTY"

  MUSH_TARGET_DIR=target/release
  exec_manifest_lookup "${PWD}"

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_release "$@"

  exec_publish
}
