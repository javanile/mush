
parser_definition_info() {
	setup REST help:usage abbr:true -- "Display metadata for a package at the current registry" ''

  msg   -- 'USAGE:' "  ${2##*/} info [OPTIONS] [package]" ''

	msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET          -q --quiet                        -- "Do not print mush log messages"
	disp  :usage         -h --help                         -- "Print help information"
}

run_info() {
  eval "$(getoptions parser_definition_info parse "$0")"
  parse "$@"
  eval "set -- $REST"

  mush_registry_index_update



  echo "Package: ${MUSH_PACKAGE_NAME}"
  echo "Version: ${MUSH_PACKAGE_VERSION}"
  echo "Type:    ${MUSH_PACKAGE_TYPE}"
}
