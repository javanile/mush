
parser_definition_fetch() {
  setup   REST help:usage abbr:true -- "Fetch dependencies of a package from the network" ''

  msg   -- 'USAGE:' "  ${2##*/} fetch [OPTIONS]" ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"

  param  BUILD_TARGET   -t --target                       -- "Check for the specific target"
  disp   :usage         -h --help                         -- "Print help information"
}

run_fetch() {
  eval "$(getoptions parser_definition_fetch parse "$0")"
  parse "$@"
  eval "set -- $REST"

  exec_manifest_lookup "${PWD}"

  local package_name="${MUSH_PACKAGE_NAME}"
  local package_version="${MUSH_PACKAGE_VERSION}"
  local pwd=${PWD}

  mush_registry_index_update

  exec_dependencies
}
