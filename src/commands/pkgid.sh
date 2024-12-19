
parser_definition_pkgid() {
	setup   REST help:usage abbr:true -- "Create a new mush package in an existing directory" ''

  msg   -- 'USAGE:' "  ${2##*/} pkgid [OPTIONS] [path]" ''

	msg -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"
	disp   :usage         -h --help                         -- "Print help information"
}

run_pkgid() {
  eval "$(getoptions parser_definition_init parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"


}
