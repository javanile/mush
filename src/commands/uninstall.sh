
parser_definition_uninstall() {
  setup  REST help:usage abbr:true -- "Remove a mush installed binary" ''

  msg    -- 'USAGE:' "  ${2##*/} uninstall [OPTIONS] [package]..." ''

  msg    -- 'OPTIONS:'
  flag   VERBOSE  -v --verbose counter:true "init:=${VERBOSE}" -- "Use verbose output (-vv or -vvv to increase level)"
  flag   QUIET    -q --quiet                                   -- "Do not print mush log messages"
  param  BIN_NAME    --bin                                     -- "Only uninstall the specified binary"
  flag   PURGE       --purge                                   -- "Also remove the local registry cache for the package"

  disp   :usage   -h --help                                    -- "Print help information"
}

run_uninstall() {
  eval "$(getoptions parser_definition_uninstall parse "$0")"
  parse "$@"
  eval "set -- $REST"

  mush_env

  if [ "$#" -eq 0 ]; then
    console_error "must specify a package to uninstall"
    exit 1
  fi

  local package_name="$1"
  local package_version=""

  if echo "$package_name" | grep -q '@'; then
    package_version="${package_name##*@}"
    package_name="${package_name%%@*}"
  fi

  exec_uninstall "$package_name" "$package_version"
}