
parser_definition_update() {
  setup REST help:usage abbr:true -- "Update dependencies as recorded in the local lock file" ''

  msg   -- 'USAGE:' "  ${2##*/} update [OPTIONS]" ''

  msg   -- 'OPTIONS:'
  flag  VERBOSE        -v --verbose "counter:true" "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"

  flag  QUIET          -q --quiet       -- "Do not print mush log messages"
  flag  DRU_RUN           --dry-run     -- "Don't actually write the lockfile"

  disp  :usage         -h --help        -- "Print help information"
}

run_update() {
  eval "$(getoptions parser_definition_update parse "$0")"
  parse "$@"
  eval "set -- $REST"

  exec_manifest_lookup "${PWD}"

  mush_registry_index_update full
}
