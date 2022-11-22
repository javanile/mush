
parser_definition_build() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS]" ''

	msg    -- 'OPTIONS:'
  flag   VERBOSE      -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET        -q --quiet                        -- "Do not print cargo log messages"
  param  BUILD_TARGET -t --target                       -- "Build for the specific target"
	disp   :usage       -h --help                         -- "Print help information"
}

run_build() {
  eval "$(getoptions parser_definition_build parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup

  console_status "Compiling" "mush-test v0.1.0 (/home/francesco/Develop/Javanile/mush/tests/rust)"

  #echo "MUSH_PACKAGE_NAME: $MUSH_PACKAGE_NAME"

  exec_legacy_build

  if [ "$BUILD_TARGET" = "dist" ]; then
    exec_build_dist "$@"
  else
    exec_build_debug "$@"
  fi

  console_status "Finished" "dev [unoptimized + debuginfo] target(s) in 0.00s"
}
