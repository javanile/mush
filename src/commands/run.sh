
parser_definition_run() {
	setup   REST error:run_args_error help:usage abbr:true -- "Run a binary or example of the local package" ''

  msg   -- 'USAGE:' "  ${2##*/} run [OPTIONS] [--] [args]..." ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
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

  MUSH_TARGET_DIR=target/debug

  exec_legacy_fetch "${MUSH_TARGET_DIR}"
  exec_legacy_build "${MUSH_TARGET_DIR}"

  exec_build_debug "$@"

  bin_file=target/debug/$MUSH_PACKAGE_NAME

  console_status "Compiling" "'${bin_file}'"

  compile_file "src/main.sh"

  console_status "Running" "'${bin_file}'"

  exec "$bin_file" "$@"
}
