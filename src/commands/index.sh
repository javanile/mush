
parser_definition_index() {
	setup REST help:usage abbr:true -- "Show or manage the index status of current registry" ''

  msg   -- 'USAGE:' "  ${2##*/} index [OPTIONS]" ''

	msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag  QUIET          -q --quiet                        -- "Do not print mush log messages"
	disp  :usage         -h --help                         -- "Print help information"
}

run_index() {
  eval "$(getoptions parser_definition_index parse "$0")"
  parse "$@"
  eval "set -- $REST"

  mush_registry_index_update

  cat "$MUSH_REGISTRY_INDEX"
}
