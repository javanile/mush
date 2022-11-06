

parser_definition_build_debug() {
	setup   REST help:usage abbr:true -- \
		"Usage: ${2##*/} legacy-fetch [options...] [arguments...]"
	msg -- '' 'getoptions subcommand example' ''
	msg -- 'Options:'
	flag    FLAG_C       -c --flag-c
	param   MODULE_NAME  -n --name
	disp    :usage       -h --help
}

run_build_debug() {
  eval "$(getoptions parser_definition_build_debug parse "$0")"
  parse "$@"
  eval "set -- $REST"
  echo "FLAG_C: $FLAG_C"
  echo "MODULE_NAME: $MODULE_NAME"

  build_file=target/debug/mush

  echo "#!/usr/bin/env bash" > $build_file
  echo "set -e" >> $build_file
  echo "source src/boot/debug_2022.sh" >> $build_file
  echo "source target/debug/legacy/getoptions.sh" >> $build_file
  echo "source src/commands/build_debug.sh" >> $build_file
  echo "source src/commands/legacy_fetch.sh" >> $build_file
  echo "source src/main.sh" >> $build_file
  echo "main \$@" >> $build_file
}
