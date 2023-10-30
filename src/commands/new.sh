
parser_definition_new() {
	setup   REST help:usage abbr:true -- "Compile the current package" ''

  msg   -- 'USAGE:' "  ${2##*/} build [OPTIONS] [SUBCOMMAND]" ''

	msg -- 'OPTIONS:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	param   BUILD_TARGET -t --target
	disp    :usage       -h --help
}

run_new() {
  eval "$(getoptions parser_definition_new parse "$0")"
  parse "$@"
  eval "set -- $REST"
  #echo "FLAG_C: $FLAG_C"
  #echo "MODULE_NAME: $MODULE_NAME"
  #echo "BUILD_TARGET: $BUILD_TARGET"

  if [ -e "$1" ]; then
    console_error "Destination '$1' already exists"
    exit 101
  fi

  mkdir -p "$1"

  cd "$1" || exit 101

  exec_init
}
