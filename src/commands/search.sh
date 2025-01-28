
parser_definition_search() {
  setup   REST help:usage abbr:true -- "Search registry for package" ''

  msg   -- 'USAGE:' "  ${2##*/} search [OPTIONS] [query]..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"

  disp   :usage         -h --help                         -- "Print help information"
}

run_search() {
  eval "$(getoptions parser_definition_install parse "$0")"
  parse "$@"
  eval "set -- $REST"

  echo "AA"
  mush_registry_index_update

  local query

  query="$1"

  echo "Query: ${query}"

  awk '{name=$1; desc=""; if (index($0, "#")) desc=substr($0, index($0, "#")); print name, desc}' \
    "${MUSH_REGISTRY_INDEX}" \
    | grep --color=auto -i "${query}"
}
