
parser_definition_search() {
  setup   REST help:usage abbr:true -- "Search registry for package" ''

  msg   -- 'USAGE:' "  ${2##*/} search [OPTIONS] [query]..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"
  flag   FORCE_REFRESH     --force-refresh                -- "Force refresh of the registry index"

  disp   :usage         -h --help                         -- "Print help information"
}

run_search() {
  eval "$(getoptions parser_definition_search parse "$0")"
  parse "$@"
  eval "set -- $REST"

  local query
  local index_update
  local cyan
  local reset

  mush_env

  query="$1"

  index_update=lazy
  [ -n "${FORCE_REFRESH}" ] && index_update=full
  mush_registry_index_update "${index_update}"

  #echo "Query: ${query}"

  awk '{name=$1; desc=""; if (index($0, "#")) desc=substr($0, index($0, "#")); printf "%-12s %s\n", name, desc}' \
      "${MUSH_REGISTRY_INDEX}" \
      | grep --color=auto -i "${query}" \
      | head -n 20

  cyan=$(mush_color '\033[36m')
  reset=$(mush_color '\033[0m')
  echo "${cyan}note${reset}: to learn more about a package, run '${cyan}mush info <name>${reset}'" >&2
}
