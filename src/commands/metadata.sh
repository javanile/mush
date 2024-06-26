
parser_definition_metadata() {
	setup REST help:usage abbr:true -- "Output the resolved dependencies of a package, the concrete used versions including overrides" ''

  msg   -- 'USAGE:' "  ${2##*/} metadata [OPTIONS] [path]" ''

	msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET          -q --quiet                        -- "Do not print mush log messages"
	disp  :usage         -h --help                         -- "Print help information"
}

run_metadata() {
  eval "$(getoptions parser_definition_metadata parse "$0")"
  parse "$@"
  eval "set -- $REST"

  exec_manifest_lookup "${PWD}"

  echo "Package: ${MUSH_PACKAGE_NAME}"
  echo "Version: ${MUSH_PACKAGE_VERSION}"
  echo "Type:    ${MUSH_PACKAGE_TYPE}"
}
