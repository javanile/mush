
parser_definition_run() {
  setup   REST error:run_args_error help:usage abbr:true -- "Run a binary or example of the local package" ''

  msg   -- 'USAGE:' "  ${2##*/} run [OPTIONS] [--] [args]..." ''

  msg -- 'OPTIONS:'
  flag   QUIET          -q --quiet                        -- "Do not print mush log messages"
  param  EXAMPLE_NAME      --example                      -- "Name of the example target to run"
  flag   VERBOSE        -v --verbose counter:true init:=0 -- "Use verbose output (-vv or -vvv to increase level)"

  disp   :usage         -h --help                         -- "Print help information"
}

run_args_error() {
  case "$2" in
    unknown)
      echo -e "\e[1m\e[31merror:\e[0m unexpected argument '\e[33m-${3}\e[0m' found"
      echo -e ""
      echo -e "\e[32m  tip:\e[0m to pass '\e[33m${3}\e[0m' as a value, use '\e[32m-- ${3}\e[0m'"
      echo -e ""
      echo -e "\e[1m\e[4mUsage:\e[0m \e[1mmush run\e[0m [OPTIONS] [args]..."
      echo -e ""
      echo -e "For more information, try '\e[1m--help\e[0m'."
      ;;
    *)
      echo "ERROR: ($2,$3) $1"
      ;;
  esac
  exit 101
}

run_run() {
  eval "$(getoptions parser_definition_run parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  exec_manifest_lookup "${PWD}"

  MUSH_TARGET_PATH=target/debug

  exec_legacy_fetch "${MUSH_TARGET_PATH}"
  exec_legacy_build "${MUSH_TARGET_PATH}"

  if [ -z "${EXAMPLE_NAME}" ]; then
    local src_file=src/main.sh
    local bin_file=target/debug/$MUSH_PACKAGE_NAME
  else
    local src_file=examples/$EXAMPLE_NAME.sh
    local bin_file=target/debug/examples/$EXAMPLE_NAME

    if [ ! -f "${src_file}" ]; then
      console_error "no example target named '${EXAMPLE_NAME}'."
      echo ""
      local examples=$(find examples/ -type f -name '*.sh' -exec basename {} .sh \; 2>/dev/null | sed 's/^/    /')
      [ -n "${examples}" ] && echo -e "Available example targets:\n${examples}\n"
      exit 101
    fi
  fi

  console_status "Compiling" "'${bin_file}'"

  local lib_file=src/lib.sh
  if [ -f "${lib_file}" ]; then
    compile_file "${lib_file}"
  else
    local lib_file=
  fi

  exec_build_debug "${src_file}" "${bin_file}" "${lib_file}"

  compile_file "${src_file}"

  console_status "Running" "'${bin_file}'"

  exec "${bin_file}" "$@"
}
