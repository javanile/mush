
parser_definition_install() {
	setup   REST help:usage abbr:true -- "Install a Mush binary. Default location is \$HOME/.mush/bin" ''

  msg   -- 'USAGE:' "  ${2##*/} install [OPTIONS] [package]..." ''

	msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print cargo log messages"
  flag   BUILD_RELEASE  -r --release                      -- "Build artifacts in release mode, with optimizations"

  param  PACKAGE_PATH      --path                         -- "Filesystem path to local package to install"
  param  BUILD_TARGET   -t --target                       -- "Build for the specific target"
	disp   :usage         -h --help                         -- "Print help information"
}

run_install() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"



  exec_manifest_lookup

  MUSH_TARGET_DIR=target/dist

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_release "$@"

  exec_install
}
